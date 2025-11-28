import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/auth/presentations/widgets/custom_text_fields.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/utils/validator.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_auth_navigation.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_submit_button.dart';

class CreateNewPasswordPage extends GetView<AuthController> {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final appTheme = context;

    return Scaffold(
      // Gradient
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //  Header Icon
            Icon(
              Icons.lock_reset_rounded,
              color: appTheme.primary,
              size: appTheme.screenWidth * 0.18,
            ),
            AppGaps.h24,

            // Title
            Text(
              s.create,
              textAlign: TextAlign.center,
              style: appTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppGaps.h12,

            // Description
            Text(
              s.set_strong_password,
              textAlign: TextAlign.center,
              style: appTheme.textTheme.bodyMedium?.copyWith(
                color: appTheme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
            AppGaps.h32,

            // New Password
            textFieldPasswordWidget(
              controller: controller.passController,
              hint: s.new_password,
              icon: Icons.lock_outline,
              isObsure: controller.isPasswordObscure,
              validator: (value) => Validator.password(context, value ?? ''),
            ),
            AppGaps.h16,

            // Confirm New Password
            textFieldPasswordWidget(
              controller: controller.confirmPassController,
              hint: s.confirm_new_password,
              icon: Icons.lock_outline,
              isObsure: controller.isConfirmPasswordObscure,
              validator: (value) => Validator.confirmPassword(
                context,
                controller.passController.text,
                controller.confirmPassController.text,
              ),
            ),
            AppGaps.h24,

            // Submit button
            buildSubmitButton(
              context: context,
              controller: controller,
              buttonText: s.update_password,
              onPressed: () async {
                if (controller.formKey.currentState!.validate()) {
                  final newPassword = controller.passController.text.trim();
                  await controller.updatePassword(newPassword);
                }
              },
            ),

            AppGaps.h32,

            // Back to Login
            buildAuthNavigation(
              context: context,
              text: s.remembered_password,
              actionText: s.log_in,
              onTap: controller.goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}
