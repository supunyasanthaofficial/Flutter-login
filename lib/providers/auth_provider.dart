import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final AuthServiceInterface authService;
  final StorageService storageService;

  AuthProvider({
    required this.authService,
    required this.storageService,
  }) {
    _initFromStorage();
  }

  AuthStatus _status = AuthStatus.unauthenticated;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Form helpers
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Getters
  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  String? get savedIdentifier => storageService.savedIdentifier;
  String? get savedPassword => storageService.savedPassword;

  void _initFromStorage() {
    _rememberMe = storageService.rememberMe;
    final cached = storageService.getCachedUser();
    if (cached != null && storageService.authToken != null) {
      _currentUser = cached;
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Perform login with email or mobile number
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;

    try {
      final response = await authService.login(
        identifier: identifier,
        password: password,
      );

      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        _status = AuthStatus.authenticated;
        _successMessage = response.message;

        // Persist session and remember me credentials
        await storageService.saveCurrentUser(_currentUser!);
        await storageService.saveCredentials(
          rememberMe: _rememberMe,
          identifier: identifier,
          password: password,
        );

        _setLoading(false);
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = response.errorMessage ?? 'Authentication failed.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  /// Perform user registration
  Future<bool> register({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;

    try {
      final response = await authService.register(
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        password: password,
      );

      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        _status = AuthStatus.authenticated;
        _successMessage = response.message;

        // Save session automatically upon successful registration
        await storageService.saveCurrentUser(_currentUser!);

        _setLoading(false);
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = response.errorMessage ?? 'Registration failed.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  /// Request password reset link
  Future<bool> forgotPassword({required String identifier}) async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;

    try {
      final response = await authService.forgotPassword(identifier: identifier);

      if (response.isSuccess) {
        _successMessage = response.message;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to send reset link.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  /// Sign out current user
  Future<void> logout() async {
    _setLoading(true);
    await authService.logout();
    await storageService.clearUserSession();

    // If remember me wasn't checked, clear credentials
    if (!_rememberMe) {
      await storageService.clearSavedCredentials();
    }

    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    _successMessage = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
