import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _agreeToTerms = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _emailFocusNode.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      SnackBarHelper.showWarning(context, AppStrings.valMustAgreeTerms);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showSuccess(
        context,
        authProvider.successMessage ?? AppStrings.mockRegisterSuccess,
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      SnackBarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Registration failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      const AuthHeader(
                        title: AppStrings.createAccount,
                        subtitle: AppStrings.registerSubtitle,
                        icon: Icons.person_add_alt_1_rounded,
                      ),
                      const SizedBox(height: 28),

                      // Full Name
                      CustomTextField(
                        controller: _fullNameController,
                        label: AppStrings.fullNameLabel,
                        hintText: AppStrings.fullNameHint,
                        prefixIcon: Icons.badge_outlined,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: Validators.validateFullName,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                      ),
                      const SizedBox(height: 18),

                      // Email Address
                      CustomTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: AppStrings.emailLabel,
                        hintText: AppStrings.emailHint,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.validateEmail,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_mobileFocusNode);
                        },
                      ),
                      const SizedBox(height: 18),

                      // Mobile Number
                      CustomTextField(
                        controller: _mobileController,
                        focusNode: _mobileFocusNode,
                        label: AppStrings.mobileLabel,
                        hintText: AppStrings.mobileHint,
                        prefixIcon: Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: Validators.validateMobile,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                      ),
                      const SizedBox(height: 18),

                      // Password
                      CustomTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: AppStrings.passwordLabel,
                        hintText: AppStrings.passwordHint,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: authProvider.obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        validator: Validators.validatePassword,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            authProvider.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                          onPressed: authProvider.togglePasswordVisibility,
                          tooltip: authProvider.obscurePassword
                              ? 'Show Password'
                              : 'Hide Password',
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Confirm Password
                      CustomTextField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        label: AppStrings.confirmPasswordLabel,
                        hintText: AppStrings.confirmPasswordHint,
                        prefixIcon: Icons.lock_reset_rounded,
                        obscureText: authProvider.obscureConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: (val) => Validators.validateConfirmPassword(
                          val,
                          _passwordController.text,
                        ),
                        onFieldSubmitted: (_) => _handleRegister(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            authProvider.obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                          onPressed:
                              authProvider.toggleConfirmPasswordVisibility,
                          tooltip: authProvider.obscureConfirmPassword
                              ? 'Show Password'
                              : 'Hide Password',
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Terms Agreement Checkbox
                      CustomCheckbox(
                        value: _agreeToTerms,
                        labelText: AppStrings.agreeToTerms,
                        onChanged: (val) {
                          setState(() {
                            _agreeToTerms = val ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Register Button
                      CustomButton(
                        text: AppStrings.registerButton,
                        isLoading: authProvider.isLoading,
                        onPressed:
                            authProvider.isLoading ? null : _handleRegister,
                        icon: Icons.person_add_rounded,
                      ),
                      const SizedBox(height: 28),

                      // Already have an account? Sign in link
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                AppStrings.loginNow,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
