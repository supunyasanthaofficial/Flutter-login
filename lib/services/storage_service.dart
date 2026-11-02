import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Storage service for persisting user preferences and session data.
class StorageService {
  static const String _keyRememberMe = 'remember_me_flag';
  static const String _keySavedIdentifier = 'saved_auth_identifier';
  static const String _keySavedPassword = 'saved_auth_password';
  static const String _keyAuthToken = 'auth_session_token';
  static const String _keyCachedUser = 'cached_user_profile';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Remember Me Credentials ---

  bool get rememberMe => _prefs.getBool(_keyRememberMe) ?? false;

  String? get savedIdentifier => _prefs.getString(_keySavedIdentifier);

  String? get savedPassword => _prefs.getString(_keySavedPassword);

  Future<void> saveCredentials({
    required bool rememberMe,
    required String identifier,
    required String password,
  }) async {
    await _prefs.setBool(_keyRememberMe, rememberMe);
    if (rememberMe) {
      await _prefs.setString(_keySavedIdentifier, identifier);
      await _prefs.setString(_keySavedPassword, password);
    } else {
      await _prefs.remove(_keySavedIdentifier);
      await _prefs.remove(_keySavedPassword);
    }
  }

  Future<void> clearSavedCredentials() async {
    await _prefs.remove(_keyRememberMe);
    await _prefs.remove(_keySavedIdentifier);
    await _prefs.remove(_keySavedPassword);
  }

  // --- Auth Token & Session ---

  String? get authToken => _prefs.getString(_keyAuthToken);

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove(_keyAuthToken);
  }

  // --- User Profile Cache ---

  Future<void> saveCurrentUser(UserModel user) async {
    await _prefs.setString(_keyCachedUser, jsonEncode(user.toJson()));
    if (user.token != null) {
      await saveAuthToken(user.token!);
    }
  }

  UserModel? getCachedUser() {
    final raw = _prefs.getString(_keyCachedUser);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUserSession() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyCachedUser);
  }
}
