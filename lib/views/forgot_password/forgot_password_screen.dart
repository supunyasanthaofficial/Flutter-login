import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.forgotPassword(
      identifier: _identifierController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showSuccess(
        context,
        authProvider.successMessage ?? AppStrings.resetLinkSent,
      );
      Navigator.pop(context);
    } else {
      SnackBarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Failed to send password reset link.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        title: AppStrings.resetPasswordTitle,
                        subtitle: AppStrings.resetPasswordSubtitle,
                        icon: Icons.lock_reset_rounded,
                      ),
                      const SizedBox(height: 32),

                      // Input Field
                      CustomTextField(
                        controller: _identifierController,
                        label: AppStrings.emailOrPhoneLabel,
                        hintText: AppStrings.emailOrPhoneHint,
                        prefixIcon: Icons.contact_mail_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: Validators.validateEmailOrPhone,
                        onFieldSubmitted: (_) => _handleResetPassword(),
                      ),
                      const SizedBox(height: 28),

                      // Reset Button
                      CustomButton(
                        text: AppStrings.sendResetLink,
                        isLoading: authProvider.isLoading,
                        onPressed: authProvider.isLoading
                            ? null
                            : _handleResetPassword,
                        icon: Icons.send_rounded,
                      ),
                      const SizedBox(height: 16),

                      // Back to login button
                      CustomButton(
                        text: AppStrings.backToLogin,
                        isOutlined: true,
                        onPressed: () => Navigator.pop(context),
                      ),
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
