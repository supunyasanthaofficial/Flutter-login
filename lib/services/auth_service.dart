import 'dart:async';
import '../core/constants/app_strings.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

/// Abstract contract for authentication operations.
abstract class AuthServiceInterface {
  Future<ApiResponse<UserModel>> login({
    required String identifier,
    required String password,
  });

  Future<ApiResponse<UserModel>> register({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
  });

  Future<ApiResponse<bool>> forgotPassword({
    required String identifier,
  });

  Future<ApiResponse<bool>> logout();
}

/// Simulated in-memory Auth Service handling network delays and error states.
class MockAuthService implements AuthServiceInterface {
  // Pre-seeded mock user store:
  // Key: normalized identifier (lowercase email or digits-only mobile) -> Map of user data + password
  final Map<String, _MockUserEntry> _mockDb = {};

  MockAuthService() {
    _seedDefaultUsers();
  }

  void _seedDefaultUsers() {
    final defaultUsers = [
      _MockUserEntry(
        user: UserModel(
          id: 'user_101',
          fullName: 'Supun Yasantha',
          email: 'demo@example.com',
          mobileNumber: '+1234567890',
          token: 'mock-jwt-token-supun-101',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        password: 'Password123',
      ),
      _MockUserEntry(
        user: UserModel(
          id: 'user_102',
          fullName: 'Jane Doe',
          email: 'jane@example.com',
          mobileNumber: '+1987654321',
          token: 'mock-jwt-token-jane-102',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        password: 'Password123',
      ),
    ];

    for (final entry in defaultUsers) {
      _mockDb[_normalizeEmail(entry.user.email)] = entry;
      _mockDb[_normalizePhone(entry.user.mobileNumber)] = entry;
    }
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  String _normalizePhone(String phone) =>
      phone.replaceAll(RegExp(r'\D'), '');

  @override
  Future<ApiResponse<UserModel>> login({
    required String identifier,
    required String password,
  }) async {
    // Simulate real-world network latency
    await Future.delayed(const Duration(milliseconds: 1000));

    final trimmed = identifier.trim();
    _MockUserEntry? entry;

    if (trimmed.contains('@')) {
      entry = _mockDb[_normalizeEmail(trimmed)];
    } else {
      entry = _mockDb[_normalizePhone(trimmed)];
    }

    if (entry == null || entry.password != password) {
      return ApiResponse.error(
        AppStrings.mockInvalidCredentials,
        statusCode: 401,
      );
    }

    // Refresh token
    final userWithToken = entry.user.copyWith(
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
    );

    return ApiResponse.success(
      userWithToken,
      message: AppStrings.mockLoginSuccess,
    );
  }

  @override
  Future<ApiResponse<UserModel>> register({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final emailKey = _normalizeEmail(email);
    final phoneKey = _normalizePhone(mobileNumber);

    // Duplicate check
    if (_mockDb.containsKey(emailKey) || _mockDb.containsKey(phoneKey)) {
      return ApiResponse.error(
        AppStrings.mockUserAlreadyExists,
        statusCode: 409,
      );
    }

    final newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final token = 'mock-jwt-$newId';
    final newUser = UserModel(
      id: newId,
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      mobileNumber: mobileNumber.trim(),
      token: token,
      createdAt: DateTime.now(),
    );

    final entry = _MockUserEntry(user: newUser, password: password);
    _mockDb[emailKey] = entry;
    _mockDb[phoneKey] = entry;

    return ApiResponse.success(
      newUser,
      message: AppStrings.mockRegisterSuccess,
      statusCode: 201,
    );
  }

  @override
  Future<ApiResponse<bool>> forgotPassword({
    required String identifier,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final trimmed = identifier.trim();
    _MockUserEntry? entry;

    if (trimmed.contains('@')) {
      entry = _mockDb[_normalizeEmail(trimmed)];
    } else {
      entry = _mockDb[_normalizePhone(trimmed)];
    }

    if (entry == null) {
      return ApiResponse.error(
        'No account found with this email or mobile number.',
        statusCode: 404,
      );
    }

    return ApiResponse.success(
      true,
      message: AppStrings.resetLinkSent,
    );
  }

  @override
  Future<ApiResponse<bool>> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(true);
  }
}

class _MockUserEntry {
  final UserModel user;
  final String password;

  _MockUserEntry({required this.user, required this.password});
}
