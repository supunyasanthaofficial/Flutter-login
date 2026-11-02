import 'package:flutter_test/flutter_test.dart';
import 'package:login/core/constants/app_strings.dart';
import 'package:login/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmailOrPhone accepts valid email and phone, rejects invalid', () {
      // Valid email
      expect(Validators.validateEmailOrPhone('test@example.com'), isNull);
      expect(Validators.validateEmailOrPhone('user.name+tag@sub.domain.co'), isNull);

      // Valid phone
      expect(Validators.validateEmailOrPhone('+1234567890'), isNull);
      expect(Validators.validateEmailOrPhone('0771234567'), isNull);
      expect(Validators.validateEmailOrPhone('+94 77 123 4567'), isNull);

      // Empty / Null
      expect(Validators.validateEmailOrPhone(''), AppStrings.valRequired);
      expect(Validators.validateEmailOrPhone(null), AppStrings.valRequired);
      expect(Validators.validateEmailOrPhone('   '), AppStrings.valRequired);

      // Invalid inputs
      expect(Validators.validateEmailOrPhone('notanemail'), AppStrings.valEnterEmailOrPhone);
      expect(Validators.validateEmailOrPhone('test@'), AppStrings.valInvalidEmail);
      expect(Validators.validateEmailOrPhone('123'), AppStrings.valEnterEmailOrPhone);
    });

    test('validateEmail validates RFC compliant emails', () {
      expect(Validators.validateEmail('user@test.com'), isNull);
      expect(Validators.validateEmail(''), AppStrings.valRequired);
      expect(Validators.validateEmail('invalid-email'), AppStrings.valInvalidEmail);
      expect(Validators.validateEmail('user@domain'), AppStrings.valInvalidEmail);
    });

    test('validateMobile validates phone numbers', () {
      expect(Validators.validateMobile('+15551234567'), isNull);
      expect(Validators.validateMobile('0771234567'), isNull);
      expect(Validators.validateMobile(''), AppStrings.valRequired);
      expect(Validators.validateMobile('123'), AppStrings.valInvalidPhone);
      expect(Validators.validateMobile('abcdefgh'), AppStrings.valInvalidPhone);
    });

    test('validateFullName validates length and characters', () {
      expect(Validators.validateFullName('Supun Yasantha'), isNull);
      expect(Validators.validateFullName('John O\'Connor'), isNull);
      expect(Validators.validateFullName('Mary-Jane'), isNull);
      expect(Validators.validateFullName(''), AppStrings.valRequired);
      expect(Validators.validateFullName('Al'), AppStrings.valNameTooShort);
      expect(Validators.validateFullName('User123!'), AppStrings.valNameInvalid);
    });

    test('validatePassword validates length and alphanumeric requirements', () {
      expect(Validators.validatePassword('Password123'), isNull);
      expect(Validators.validatePassword('securePass1'), isNull);
      expect(Validators.validatePassword(''), AppStrings.valRequired);
      expect(Validators.validatePassword('Pass1'), AppStrings.valPasswordTooShort);
      expect(Validators.validatePassword('passwordonly'), AppStrings.valPasswordRequirements);
      expect(Validators.validatePassword('1234567890'), AppStrings.valPasswordRequirements);
    });

    test('validateConfirmPassword ensures password match', () {
      expect(Validators.validateConfirmPassword('Secret123', 'Secret123'), isNull);
      expect(Validators.validateConfirmPassword('', 'Secret123'), AppStrings.valRequired);
      expect(Validators.validateConfirmPassword('Mismatch123', 'Secret123'),
          AppStrings.valPasswordsDoNotMatch);
    });
  });
}
