import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/auth/presentations/widgets/custom_text_fields.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/utils/validator.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_auth_navigation.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_submit_button.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context;
    final s = context.s;

    return Container(
      // Gradient
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
            buildSubmitButton(
              context: context,
              controller: controller,
              buttonText: s.buttonSignUp,
              onPressed: () async {
                if (controller.formKey.currentState!.validate()) {
                  await controller.signUp(
                    controller.nameController.text,
                    controller.emailController.text,
                    controller.passController.text,
                  );
                }
              },
            ),

            AppGaps.h32,

            // Already have an account
            buildAuthNavigation(
              context: context,
              text: s.alreadyHaveAccount,
              actionText: s.buttonLogin,
              onTap: controller.goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}
