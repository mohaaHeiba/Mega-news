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
    final s = context.s;

    // Cleaned up: Removed outer decoration, now just content
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name
          textFieldWidget(
            controller: controller.nameController,
            hint: s.hintFullName,
            label: s.labelFullName,
            icon: Icons.person_outline_rounded,
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
            icon: Icons.lock_outline_rounded,
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
            icon: Icons.lock_outline_rounded,
            isObsure: controller.isConfirmPasswordObscure,
            validator: (value) => Validator.confirmPassword(
              context,
              controller.passController.text,
              controller.confirmPassController.text,
            ),
          ),
          AppGaps.h32,

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

          // Already have an account Link
          Center(
            child: buildAuthNavigation(
              context: context,
              text: s.alreadyHaveAccount,
              actionText: s.buttonLogin,
              onTap: controller.goToLogin,
            ),
          ),
          AppGaps.h24,
        ],
      ),
    );
  }
}
