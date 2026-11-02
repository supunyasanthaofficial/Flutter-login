import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Storage service for persisting user preferences and session data.
/// Includes an in-memory fallback mechanism to prevent crashes when
/// native plugins have not been compiled yet (e.g. during Hot Restart).
class StorageService {
  static const String _keyRememberMe = 'remember_me_flag';
  static const String _keySavedIdentifier = 'saved_auth_identifier';
  static const String _keySavedPassword = 'saved_auth_password';
  static const String _keyAuthToken = 'auth_session_token';
  static const String _keyCachedUser = 'cached_user_profile';

  final SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryFallback = {};

  StorageService([this._prefs]);

  /// Initializes the storage service with SharedPreferences.
  /// If native plugin bindings are missing (such as during Hot Restart right
  /// after adding a dependency), gracefully falls back to memory storage.
  static Future<StorageService> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return StorageService(prefs);
    } catch (e) {
      debugPrint(
        '[StorageService] Native SharedPreferences plugin not attached ($e). '
        'Falling back to in-memory storage. Stop the running app and run "flutter run" '
        'to build with native plugin bindings.',
      );
      return StorageService(null);
    }
  }

  // --- Remember Me Credentials ---

  bool get rememberMe {
    final prefs = _prefs;
    if (prefs != null) {
      return prefs.getBool(_keyRememberMe) ?? false;
    }
    return _memoryFallback[_keyRememberMe] as bool? ?? false;
  }

  String? get savedIdentifier {
    final prefs = _prefs;
    if (prefs != null) {
      return prefs.getString(_keySavedIdentifier);
    }
    return _memoryFallback[_keySavedIdentifier] as String?;
  }

  String? get savedPassword {
    final prefs = _prefs;
    if (prefs != null) {
      return prefs.getString(_keySavedPassword);
    }
    return _memoryFallback[_keySavedPassword] as String?;
  }

  Future<void> saveCredentials({
    required bool rememberMe,
    required String identifier,
    required String password,
  }) async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setBool(_keyRememberMe, rememberMe);
      if (rememberMe) {
        await prefs.setString(_keySavedIdentifier, identifier);
        await prefs.setString(_keySavedPassword, password);
      } else {
        await prefs.remove(_keySavedIdentifier);
        await prefs.remove(_keySavedPassword);
      }
    } else {
      _memoryFallback[_keyRememberMe] = rememberMe;
      if (rememberMe) {
        _memoryFallback[_keySavedIdentifier] = identifier;
        _memoryFallback[_keySavedPassword] = password;
      } else {
        _memoryFallback.remove(_keySavedIdentifier);
        _memoryFallback.remove(_keySavedPassword);
      }
    }
  }

  Future<void> clearSavedCredentials() async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.remove(_keyRememberMe);
      await prefs.remove(_keySavedIdentifier);
      await prefs.remove(_keySavedPassword);
    } else {
      _memoryFallback.remove(_keyRememberMe);
      _memoryFallback.remove(_keySavedIdentifier);
      _memoryFallback.remove(_keySavedPassword);
    }
  }

  // --- Auth Token & Session ---

  String? get authToken {
    final prefs = _prefs;
    if (prefs != null) {
      return prefs.getString(_keyAuthToken);
    }
    return _memoryFallback[_keyAuthToken] as String?;
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setString(_keyAuthToken, token);
    } else {
      _memoryFallback[_keyAuthToken] = token;
    }
  }

  Future<void> clearAuthToken() async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.remove(_keyAuthToken);
    } else {
      _memoryFallback.remove(_keyAuthToken);
    }
  }

  // --- User Profile Cache ---

  Future<void> saveCurrentUser(UserModel user) async {
    final raw = jsonEncode(user.toJson());
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setString(_keyCachedUser, raw);
    } else {
      _memoryFallback[_keyCachedUser] = raw;
    }
    if (user.token != null) {
      await saveAuthToken(user.token!);
    }
  }

  UserModel? getCachedUser() {
    final prefs = _prefs;
    final raw = prefs != null
        ? prefs.getString(_keyCachedUser)
        : _memoryFallback[_keyCachedUser] as String?;

    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUserSession() async {
    await clearAuthToken();
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.remove(_keyCachedUser);
    } else {
      _memoryFallback.remove(_keyCachedUser);
    }
  }
}
