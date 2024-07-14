import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/config/constants/app_colors.dart';
import 'package:foharmalai/config/constants/app_sizes.dart';
import 'package:foharmalai/core/common/widgets/custom_snackbar.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';
import 'package:foharmalai/core/utils/validators/validators.dart';
import 'package:foharmalai/features/forgot_password/service/auth_serivce.dart';
import 'package:iconsax/iconsax.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return FlutterSecureStorage();
});

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForgotPasswordRequest(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authService = ref.read(authServiceProvider);

    try {
      bool success =
          await authService.sendPasswordResetEmail(_emailController.text);
      if (success) {
        showSnackBar(
          context: context,
          message: 'Password reset email sent successfully',
          color: Colors.green,
        );
        Navigator.pop(context);
      } else {
        showSnackBar(
          context: context,
          message: 'Failed to send password reset email',
          color: AppColors.error,
        );
      }
    } catch (error) {
      showSnackBar(
        context: context,
        message: 'An error occurred. Please try again.',
        color: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('forgot_password')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.dark : AppColors.shadepink,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: isDarkMode ? AppColors.warning : AppColors.error,
                      width: 1,
                    ),
                  ),
                  child: Text(localizations.translate('forgot_password_desc')),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),
                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: localizations.translate('email'),
                    prefixIcon: Icon(Iconsax.sms),
                    hintText: localizations.translate('email_hint'),
                  ),
                  validator: (value) => AppValidator.validateEmail(value),
                ),
                const SizedBox(height: AppSizes.spaceBtwnInputFields),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submitForgotPasswordRequest(ref),
                    child: Text(localizations.translate('submit')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
