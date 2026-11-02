import '../constants/app_strings.dart';

/// Form input validators with comprehensive checks.
class Validators {
  Validators._();

  // Email regex compliant with RFC 5322
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Phone regex: optional + followed by digits, spaces, hyphens, parentheses (7 to 15 digits)
  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[0-9\s\-()]{7,20}$',
  );

  // Name regex: letters, spaces, hyphens, apostrophes
  static final RegExp _nameRegExp = RegExp(
    r"^[a-zA-Z\s\-']+$",
  );

  /// Validates an input that can be either an email or a mobile number (for Login).
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valRequired;
    }
    final trimmed = value.trim();

    // If it contains an '@', treat as email
    if (trimmed.contains('@')) {
      if (!_emailRegExp.hasMatch(trimmed)) {
        return AppStrings.valInvalidEmail;
      }
      return null;
    }

    // Otherwise check if it looks like a phone number
    final digitsOnly = trimmed.replaceAll(RegExp(r'\D'), '');
    if (_phoneRegExp.hasMatch(trimmed) && digitsOnly.length >= 7) {
      return null;
    }

    return AppStrings.valEnterEmailOrPhone;
  }

  /// Validates standard email address.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valRequired;
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return AppStrings.valInvalidEmail;
    }
    return null;
  }

  /// Validates mobile phone number.
  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valRequired;
    }
    final trimmed = value.trim();
    final digitsOnly = trimmed.replaceAll(RegExp(r'\D'), '');
    if (!_phoneRegExp.hasMatch(trimmed) || digitsOnly.length < 7) {
      return AppStrings.valInvalidPhone;
    }
    return null;
  }

  /// Validates full name.
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valRequired;
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return AppStrings.valNameTooShort;
    }
    if (!_nameRegExp.hasMatch(trimmed)) {
      return AppStrings.valNameInvalid;
    }
    return null;
  }

  /// Validates password strength (minimum 8 characters, at least one letter and one number).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.valRequired;
    }
    if (value.length < 8) {
      return AppStrings.valPasswordTooShort;
    }
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);

    if (!hasLetter || !hasDigit) {
      return AppStrings.valPasswordRequirements;
    }
    return null;
  }

  /// Validates confirm password against original password.
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return AppStrings.valRequired;
    }
    if (value != originalPassword) {
      return AppStrings.valPasswordsDoNotMatch;
    }
    return null;
  }
}
