import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/common_widgets/inputs/custom_text_fields.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/utils/validator.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context;
    final s = context.s;

    return Container(
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
            // Header Icon
            Icon(
              Icons.person_add_alt_1_rounded,
              color: appTheme.primary.withOpacity(0.9),
              size: appTheme.screenWidth * 0.18,
            ),
            AppGaps.h24,

            // Title
            Text(
              s.registerTitle,
              textAlign: TextAlign.center,
              style: appTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.onBackground,
              ),
            ),
            AppGaps.h12,

            // Description
            Text(
              s.registerSubtitle,
              textAlign: TextAlign.center,
              style: appTheme.textTheme.bodyMedium?.copyWith(
                color: appTheme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            AppGaps.h32,

            // Full Name
            textFieldWidget(
              controller: controller.nameController,
              hint: s.hintFullName,
              label: s.labelFullName,
              icon: Icons.person_outline,
              validator: (value) =>
                  Validator.name(context, controller.nameController.text),
            ),
            AppGaps.h16,

            // Email
            textFieldWidget(
              controller: controller.emailController,
              hint: s.hintEmail,
              label: s.labelEmail,
              icon: Icons.email_outlined,
              inputType: TextInputType.emailAddress,
              validator: (value) =>
                  Validator.email(context, controller.emailController.text),
            ),
            AppGaps.h16,

            // Password
            textFieldPasswordWidget(
              controller: controller.passController,
              hint: s.hintPassword,
              label: s.labelPassword,
              icon: Icons.lock_outline,
              isObsure: controller.isPasswordObscure,
              validator: (value) =>
                  Validator.password(context, controller.passController.text),
            ),
            AppGaps.h16,

            // Confirm Password
            textFieldPasswordWidget(
              controller: controller.confirmPassController,
              hint: s.hintConfirmPassword,
              label: s.labelConfirmPassword,
              icon: Icons.lock_outline,
              isObsure: controller.isConfirmPasswordObscure,
              validator: (value) => Validator.confirmPassword(
                context,
                controller.passController.text,
                controller.confirmPassController.text,
              ),
            ),
            AppGaps.h24,

            // Sign Up button
            SizedBox(
              height: 54,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (controller.formKey.currentState!.validate()) {
                            try {
                              controller.isLoading.value = true;
                              await controller.signUp(
                                controller.nameController.text,
                                controller.emailController.text,
                                controller.passController.text,
                              );
                            } finally {
                              controller.isLoading.value = false;
                            }
                          }
                        },
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(
                          s.buttonSignUp,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.background,
                          ),
                        ),
                ),
              ),
            ),
            AppGaps.h32,

            // Already have an account
            Center(
              child: GestureDetector(
                onTap: controller.goToLogin,
                child: RichText(
                  text: TextSpan(
                    text: "${s.alreadyHaveAccount} ",
                    style: appTheme.textTheme.bodyMedium?.copyWith(
                      color: appTheme.textTheme.bodyMedium?.color?.withOpacity(
                        0.85,
                      ),
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: s.buttonLogin,
                        style: TextStyle(
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
    );
  }
}
