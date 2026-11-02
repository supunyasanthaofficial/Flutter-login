import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/core/constants/app_strings.dart';
import 'package:login/core/constants/app_theme.dart';
import 'package:login/providers/auth_provider.dart';
import 'package:login/providers/theme_provider.dart';
import 'package:login/routes/app_routes.dart';
import 'package:login/services/auth_service.dart';
import 'package:login/services/storage_service.dart';
import 'package:login/views/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget({
    required AuthServiceInterface authService,
    required StorageService storageService,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: authService,
            storageService: storageService,
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
        routes: AppRoutes.routes,
      ),
    );
  }

  testWidgets('LoginScreen renders all essential fields and elements',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    final authService = MockAuthService();

    await tester.pumpWidget(
      createTestWidget(
        authService: authService,
        storageService: storageService,
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text(AppStrings.welcomeBack), findsOneWidget);
    expect(find.text(AppStrings.loginSubtitle), findsOneWidget);

    // Verify Input Fields
    expect(find.text(AppStrings.emailOrPhoneLabel), findsOneWidget);
    expect(find.text(AppStrings.passwordLabel), findsOneWidget);

    // Verify Remember Me checkbox and Forgot Password
    expect(find.text(AppStrings.rememberMe), findsOneWidget);
    expect(find.text(AppStrings.forgotPassword), findsOneWidget);

    // Verify Sign In Button
    expect(find.text(AppStrings.signInButton), findsOneWidget);

    // Verify Register link
    expect(find.text(AppStrings.registerNow), findsOneWidget);
  });

  testWidgets('Triggering login with empty fields displays validation errors',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    final authService = MockAuthService();

    await tester.pumpWidget(
      createTestWidget(
        authService: authService,
        storageService: storageService,
      ),
    );
    await tester.pumpAndSettle();

    // Click Sign In button without entering any values
    final signInBtn = find.text(AppStrings.signInButton);
    await tester.ensureVisible(signInBtn);
    await tester.tap(signInBtn);
    await tester.pumpAndSettle();

    // Both fields should show validation errors
    expect(find.text(AppStrings.valRequired), findsNWidgets(2));
  });

  testWidgets('Show / Hide password toggle toggles obscureText',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    final authService = MockAuthService();

    await tester.pumpWidget(
      createTestWidget(
        authService: authService,
        storageService: storageService,
      ),
    );
    await tester.pumpAndSettle();

    // Find password field
    final passwordFields = find.byType(EditableText);
    expect(passwordFields, findsNWidgets(2));

    // Initial state: password field is obscured
    final passwordEditable = tester.widget<EditableText>(passwordFields.last);
    expect(passwordEditable.obscureText, isTrue);

    // Tap toggle icon
    final toggleIcon = find.byTooltip('Show Password');
    expect(toggleIcon, findsOneWidget);
    await tester.ensureVisible(toggleIcon);
    await tester.tap(toggleIcon);
    await tester.pumpAndSettle();

    // After toggle: password field is revealed
    final updatedEditable =
        tester.widget<EditableText>(find.byType(EditableText).last);
    expect(updatedEditable.obscureText, isFalse);
  });
}
