import 'package:flutter_test/flutter_test.dart';
import 'package:login/core/constants/app_strings.dart';
import 'package:login/services/auth_service.dart';

void main() {
  group('MockAuthService Tests', () {
    late MockAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('login with valid seeded email succeeds', () async {
      final response = await authService.login(
        identifier: 'demo@example.com',
        password: 'Password123',
      );

      expect(response.isSuccess, isTrue);
      expect(response.data, isNotNull);
      expect(response.data?.email, 'demo@example.com');
      expect(response.data?.fullName, 'Supun Yasantha');
      expect(response.data?.token, isNotNull);
    });

    test('login with valid seeded phone succeeds', () async {
      final response = await authService.login(
        identifier: '+1234567890',
        password: 'Password123',
      );

      expect(response.isSuccess, isTrue);
      expect(response.data, isNotNull);
      expect(response.data?.email, 'demo@example.com');
    });

    test('login with incorrect password fails with error', () async {
      final response = await authService.login(
        identifier: 'demo@example.com',
        password: 'WrongPassword!',
      );

      expect(response.isSuccess, isFalse);
      expect(response.errorMessage, AppStrings.mockInvalidCredentials);
      expect(response.statusCode, 401);
    });

    test('login with non-existent user fails', () async {
      final response = await authService.login(
        identifier: 'unknown@example.com',
        password: 'Password123',
      );

      expect(response.isSuccess, isFalse);
      expect(response.errorMessage, AppStrings.mockInvalidCredentials);
      expect(response.statusCode, 401);
    });

    test('register a new user succeeds', () async {
      final response = await authService.register(
        fullName: 'New User',
        email: 'newuser@example.com',
        mobileNumber: '+94770001122',
        password: 'Password123',
      );

      expect(response.isSuccess, isTrue);
      expect(response.data?.fullName, 'New User');
      expect(response.data?.email, 'newuser@example.com');

      // Check subsequent login works for this newly registered user
      final loginResponse = await authService.login(
        identifier: 'newuser@example.com',
        password: 'Password123',
      );
      expect(loginResponse.isSuccess, isTrue);
    });

    test('register with duplicate email returns error', () async {
      final response = await authService.register(
        fullName: 'Duplicate',
        email: 'demo@example.com',
        mobileNumber: '+1999888777',
        password: 'Password123',
      );

      expect(response.isSuccess, isFalse);
      expect(response.statusCode, 409);
      expect(response.errorMessage, AppStrings.mockUserAlreadyExists);
    });

    test('forgotPassword returns success for registered user and error for unknown', () async {
      final successResponse =
          await authService.forgotPassword(identifier: 'demo@example.com');
      expect(successResponse.isSuccess, isTrue);

      final failResponse =
          await authService.forgotPassword(identifier: 'ghost@domain.com');
      expect(failResponse.isSuccess, isFalse);
      expect(failResponse.statusCode, 404);
    });
  });
}
