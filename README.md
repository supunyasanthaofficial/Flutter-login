# Authify - Flutter Login & Registration Module

[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.4-0175C2?logo=dart)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State%20Management-Provider-4F46E5)](https://pub.dev/packages/provider)
[![Tests](https://img.shields.io/badge/Tests-16%20Passed-10B981)](#testing)

A functional, responsive, and production-ready Login & Registration module built with Flutter following clean architecture principles, Material 3 design standards, and comprehensive input validation.

---

## 🌟 Key Features

### 🔐 Login Screen
- **Dual Identifier Input**: Supports both Email addresses and Mobile phone numbers with intelligent auto-detection and validation.
- **Show / Hide Password**: Interactive visibility toggle for enhanced security and convenience.
- **Remember Me**: Persists credentials and session state across app restarts using `SharedPreferences`.
- **Forgot Password Flow**: Complete reset link request flow with input validation and feedback.
- **Loading State**: Responsive loading spinner on authentication requests to prevent duplicate submissions.
- **Demo Autofill**: Quick one-tap "AUTOFILL" badge to immediately test with pre-seeded demo accounts.
- **Social Sign-In UI**: Styled Google and Apple sign-in options.

### 📝 Registration Screen
- **Full Name**: Validated for minimum length and valid character set.
- **Email Address**: RFC 5322 regex validation.
- **Mobile Number**: International and local format support with minimum digit validation.
- **Password & Confirm Password**:
  - Enforces minimum 8 characters and alphanumeric complexity.
  - Real-time match verification between password and confirm password fields.
  - Individual show/hide toggles for both password fields.
- **Terms & Privacy Checkbox**: User agreement validation before registration.
- **Loading State**: Animated progress indicator during registration.

### 🏠 Dashboard / Home Screen
- Displays the authenticated user's profile card, avatar, email, and mobile number.
- Shows real-time session status, mock JWT token, and "Remember Me" persistence status.
- Sign Out confirmation dialog that cleanly clears or retains credentials based on user preference.

### 🎨 UI / UX & Responsiveness
- **Theme Support**: Seamless Light Mode and Dark Mode switching.
- **Responsive Layout**: Designed for mobile phones, tablets, and desktop/web screens (`ConstrainedBox` with max width constraints, avoiding unwanted stretching).
- **Zero Overflow Guarantee**: Uses `SingleChildScrollView`, `SafeArea`, `Wrap`, and `Flexible` containers to ensure no RenderFlex overflows on any screen size.
- **Custom Feedback**: Styled floating SnackBars for Success, Error, Info, and Warning states.

---

## 🏗️ Architecture & Project Structure

The project strictly separates UI, Models, Services, and State Controllers (Providers):

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Color definitions & gradients (Light & Dark)
│   │   ├── app_strings.dart        # Centralized UI and validation strings
│   │   ├── app_text_styles.dart    # Typography scale
│   │   └── app_theme.dart          # Light and Dark ThemeData (Material 3)
│   └── utils/
│       ├── snackbar_helper.dart    # Floating banner notifications
│       └── validators.dart         # RFC Email, Phone, Name, Password validation rules
├── models/
│   ├── api_response.dart           # Generic API response wrapper (success/failure)
│   └── user_model.dart             # Authenticated user profile data model
├── providers/
│   ├── auth_provider.dart          # Authentication controller & state management
│   └── theme_provider.dart         # Theme mode controller (Light / Dark)
├── routes/
│   └── app_routes.dart             # Named routes with smooth slide/fade transitions
├── services/
│   ├── auth_service.dart           # AuthServiceInterface & MockAuthService with network delay
│   └── storage_service.dart        # SharedPreferences wrapper for persistence
├── views/
│   ├── forgot_password/
│   │   └── forgot_password_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── login/
│   │   └── login_screen.dart
│   └── register/
│       └── register_screen.dart
├── widgets/
│   ├── auth_header.dart            # Brand icon, title, and subtitle header
│   ├── custom_button.dart          # Primary / secondary button with loading indicator
│   ├── custom_checkbox.dart        # Accessible checkbox with interactive label
│   ├── custom_text_field.dart      # Standardized input field with prefix/suffix icons
│   └── social_login_button.dart    # Google & Apple sign-in buttons
└── main.dart                       # App entrypoint with MultiProvider configuration
```

---

## 🔑 Pre-Seeded Demo Credentials

For testing and demonstration, the mock authentication database is pre-populated with:

| Email / Identifier | Mobile Number | Password | Name |
| :--- | :--- | :--- | :--- |
| `demo@example.com` | `+1234567890` | `Password123` | Supun Yasantha |
| `jane@example.com` | `+1987654321` | `Password123` | Jane Doe |

*Note: You can also register any new account on the Registration Screen, and it will immediately be recognized by the login system!*

---

## 🧪 Testing

The repository contains 16 comprehensive unit and widget tests covering:
- **Validators**: Email regex, phone number formats, name length, password strength, confirmation matching.
- **Auth Service**: Simulated network latency, valid login, invalid password, unregistered user, duplicate registration, password reset.
- **Widget Tests**: Rendering of all required fields, form validation trigger on empty submission, and show/hide password toggle behavior.

Run the test suite with:
```bash
flutter test
```

Result:
```
00:09 +16: All tests passed!
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.13.0 or later)
- Dart SDK (v3.1.0 or later)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/supunyasanthaofficial/Flutter-login.git
   cd Flutter-login
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

4. Launch the application:
   ```bash
   # Run on connected device or emulator
   flutter run

   # Or run on Chrome / Web
   flutter run -d chrome

   # Or run on Windows Desktop
   flutter run -d windows
   ```

---

## 📋 Acceptance Criteria Checklist

- [x] **Email / mobile number input** on Login screen.
- [x] **Password input with show / hide password toggle** on Login screen.
- [x] **Remember me option** with persistent storage across restarts.
- [x] **Forgot password navigation** and functional request flow.
- [x] **Login button with loading indicator**.
- [x] **Registration Screen** with Full Name, Email, Mobile, Password & Confirm Password.
- [x] **Complete form input validation** for all fields.
- [x] **Clean architecture**: Separated UI, models, services, and controllers (providers).
- [x] **State Management**: Implemented using `provider`.
- [x] **Reusable UI components** (`CustomTextField`, `CustomButton`, `AuthHeader`, `CustomCheckbox`, `SocialLoginButton`).
- [x] **Responsive UI** working seamlessly without RenderFlex overflows.
- [x] **Error & Success handling** via styled SnackBars and status codes.
- [x] **Zero analysis errors** (`flutter analyze` passed).
- [x] **100% test pass rate** (16/16 unit and widget tests passed).
