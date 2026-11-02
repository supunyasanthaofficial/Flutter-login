/// Centralized string constants for UI and validation.
class AppStrings {
  AppStrings._();

  // App Identity
  static const String appName = 'Authify';
  static const String appTagline = 'Secure Authentication Portal';

  // Login Screen
  static const String welcomeBack = 'Welcome Back';
  static const String loginSubtitle = 'Please sign in to access your account';
  static const String emailOrPhoneLabel = 'Email or Mobile Number';
  static const String emailOrPhoneHint = 'name@example.com or +1234567890';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot Password?';
  static const String signInButton = 'Sign In';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String registerNow = 'Register now';
  static const String orSignInWith = 'Or continue with';

  // Registration Screen
  static const String createAccount = 'Create Account';
  static const String registerSubtitle = 'Fill in your details to get started';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'e.g. Supun Yasantha';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'e.g. supun@example.com';
  static const String mobileLabel = 'Mobile Number';
  static const String mobileHint = 'e.g. +1 555 123 4567';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String agreeToTerms = 'I agree to the Terms & Privacy Policy';
  static const String registerButton = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String loginNow = 'Sign in';

  // Forgot Password Screen
  static const String resetPasswordTitle = 'Reset Password';
  static const String resetPasswordSubtitle =
      'Enter your email or phone number and we will send you a reset link.';
  static const String sendResetLink = 'Send Reset Link';
  static const String backToLogin = 'Back to Sign In';
  static const String resetLinkSent =
      'Password reset link has been dispatched to your email/phone.';

  // Home Screen
  static const String dashboard = 'Dashboard';
  static const String welcome = 'Welcome back,';
  static const String accountDetails = 'Account Profile';
  static const String logout = 'Sign Out';
  static const String logoutConfirmTitle = 'Sign Out';
  static const String logoutConfirmMessage =
      'Are you sure you want to sign out of your account?';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';

  // Validation Messages
  static const String valRequired = 'This field is required';
  static const String valEnterEmailOrPhone = 'Enter a valid email address or phone number';
  static const String valInvalidEmail = 'Please enter a valid email address';
  static const String valInvalidPhone = 'Please enter a valid phone number (min 7 digits)';
  static const String valNameTooShort = 'Name must be at least 3 characters long';
  static const String valNameInvalid = 'Name should only contain letters and spaces';
  static const String valPasswordTooShort = 'Password must be at least 8 characters';
  static const String valPasswordRequirements =
      'Password must contain letters and at least one number';
  static const String valPasswordsDoNotMatch = 'Passwords do not match';
  static const String valMustAgreeTerms = 'You must agree to the Terms & Privacy Policy';

  // Mock API & Service Messages
  static const String mockLoginSuccess = 'Logged in successfully!';
  static const String mockRegisterSuccess = 'Account registered successfully! Welcome aboard.';
  static const String mockInvalidCredentials = 'Invalid email/phone or password.';
  static const String mockUserAlreadyExists =
      'An account with this email or mobile number already exists.';
}
