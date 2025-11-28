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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info Card with icon and instructions
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

          AppGaps.h16,

          // Resend Link Button (Added Here)
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () async {
                if (controller.emailController.text.isNotEmpty &&
                    GetUtils.isEmail(controller.emailController.text)) {
                  await controller.resendForgotPasswordEmail(
                    controller.emailController.text.trim(),
                  );
                } else {
                  controller.formKey.currentState?.validate();
                }
              },
              icon: Icon(
                Icons.refresh_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                "Resend Link",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          AppGaps.h24,

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
