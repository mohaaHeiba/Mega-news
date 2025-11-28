import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/auth/presentations/widgets/custom_text_fields.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/utils/validator.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_auth_navigation.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_submit_button.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info Card with icon and instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                AppGaps.h12,
                Text(
                  // s.forgotPasswordInstruction ??
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          AppGaps.h32,

          // Email Field
          textFieldWidget(
            controller: controller.emailController,
            label: s.labelEmail,
            hint: s.hintEmail,
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            validator: (value) => Validator.email(context, value ?? ''),
          ),

          AppGaps.h32,

          // Send Reset Link Button
          buildSubmitButton(
            context: context,
            controller: controller,
            buttonText: s.buttonSendResetLink,
            onPressed: () async {
              if (controller.formKey.currentState!.validate()) {
                await controller.resetPassword();
              }
            },
          ),

          AppGaps.h32,

          // Back to Login
          Center(
            child: buildAuthNavigation(
              context: context,
              text: s.rememberPassword,
              actionText: s.buttonLogin,
              onTap: controller.backFromForgotPass,
            ),
          ),
        ],
      ),
    );
  }
}
