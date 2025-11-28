import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/features/auth/presentations/widgets/custom_text_fields.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/utils/validator.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_auth_navigation.dart';
import 'package:mega_news/features/auth/presentations/widgets/build_submit_button.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);

    // Removed Container decoration. This is now transparent content.
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          textFieldWidget(
            controller: controller.emailController,
            label: s.email,
            hint: s.enter_email,
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            validator: (value) => Validator.email(context, value ?? ''),
          ),
          AppGaps.h24,

          // Password Field
          textFieldPasswordWidget(
            controller: controller.passController,
            label: s.password,
            hint: s.enter_password,
            icon: Icons.lock_outline_rounded,
            isObsure: controller.isPasswordObscure,
            validator: (value) => Validator.password(context, value ?? ''),
          ),

          // Forgot Password
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: controller.goToForgotPass,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0),
              ),
              child: Text(
                s.forgot_password,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          AppGaps.h24,

          // Log In Button
          buildSubmitButton(
            context: context,
            controller: controller,
            buttonText: s.log_in,
            onPressed: () async {
              if (controller.formKey.currentState!.validate()) {
                await controller.signIn(
                  email: controller.emailController.text.trim(),
                  password: controller.passController.text.trim(),
                );
              }
            },
          ),

          AppGaps.h32,

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  s.or_continue_with,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          AppGaps.h24,

          // Google Sign-In Button
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: controller.googleSignIn,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logoGoogle, height: 24),
                  const SizedBox(width: 12),
                  Text(
                    s.sign_in_with_google,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AppGaps.h32,

          // Sign Up Link
          Center(
            child: buildAuthNavigation(
              context: context,
              text: s.dont_have_account,
              actionText: s.sign_up,
              onTap: controller.goToRegister,
            ),
          ),
          AppGaps.h24,
        ],
      ),
    );
  }
}
