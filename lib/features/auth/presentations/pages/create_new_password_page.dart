import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/custom/inputs/custom_text_fields.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/utils/validator.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

class CreateNewPasswordPage extends GetView<AuthController> {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final appTheme = context;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primary.withOpacity(0.5),
              context.background,
              context.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
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
              SizedBox(
                height: 54,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (controller.formKey.currentState!.validate()) {
                              final newPassword = controller.passController.text
                                  .trim();
                              await controller.updatePassword(newPassword);
                            }
                          },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: appTheme.onPrimary)
                        : Text(
                            s.update_password,
                            style: appTheme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ),
              AppGaps.h32,

              // Back to Login
              Center(
                child: GestureDetector(
                  onTap: controller.goToLogin,
                  child: RichText(
                    text: TextSpan(
                      text: s.remembered_password,
                      style: appTheme.textTheme.bodyMedium?.copyWith(
                        color: appTheme.textTheme.bodyMedium?.color
                            ?.withOpacity(0.7),
                      ),
                      children: [
                        TextSpan(
                          text: s.log_in,
                          style: appTheme.textTheme.bodyMedium?.copyWith(
                            color: appTheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
