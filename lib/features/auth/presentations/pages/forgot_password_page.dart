import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final appTheme = context;

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              Icon(
                Icons.lock_reset_rounded,
                color: appTheme.primary,
                size: appTheme.screenWidth * 0.18,
              ),
              AppGaps.h24,

              // Title
              Text(
                s.forgotPasswordTitle,
                textAlign: TextAlign.center,
                style: appTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: appTheme.onBackground,
                ),
              ),
              AppGaps.h12,

              // Description
              Text(
                s.forgotPasswordSubtitle,
                textAlign: TextAlign.center,
                style: appTheme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.onSurface.withOpacity(0.8),
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
                validator: (value) => validator.validateEmail(value ?? ''),
              ),
              AppGaps.h24,

              // Send Reset Link Button
              Obx(
                () => SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (controller.formKey.currentState!.validate()) {
                              controller.isLoading.value = true;
                              await controller.resetPassword();
                              controller.isLoading.value = false;
                            }
                          },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: appTheme.onPrimary)
                        : Text(
                            s.buttonSendResetLink,
                            style: appTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ),
              AppGaps.h24,

              // Back to Login
              Center(
                child: GestureDetector(
                  onTap: controller.backFromForgotPass,
                  child: RichText(
                    text: TextSpan(
                      text: "${s.rememberPassword} ",
                      style: appTheme.textTheme.bodyMedium?.copyWith(
                        color: appTheme.onSurface.withOpacity(0.7),
                      ),
                      children: [
                        TextSpan(
                          text: s.buttonLogin,
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
