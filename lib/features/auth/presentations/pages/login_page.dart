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
    final appTheme = context;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo / Header
          Icon(
            Icons.lock_outline_rounded,
            color: appTheme.primary,
            size: appTheme.screenWidth * 0.18,
          ),
          AppGaps.h24,

          // Title
          Text(
            s.welcome_back,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.headlineSmall?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: appTheme.onBackground,
            ),
          ),
          AppGaps.h12,

          // Subtitle
          Text(
            s.login_to_continue,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: appTheme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          AppGaps.h32,

          // Email Field
          textFieldWidget(
            controller: controller.emailController,
            label: s.email,
            hint: s.enter_email,
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            validator: (value) => Validator.email(context, value ?? ''),
          ),
          AppGaps.h16,

          // Password Field
          textFieldPasswordWidget(
            controller: controller.passController,
            label: s.password,
            hint: s.enter_password,
            icon: Icons.lock_outline,
            isObsure: controller.isPasswordObscure,
            validator: (value) => Validator.password(context, value ?? ''),
          ),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.goToForgotPass,
              child: Text(
                s.forgot_password,
                style: appTheme.textTheme.bodySmall?.copyWith(
                  color: appTheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: appTheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          AppGaps.h12,

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
              Expanded(
                child: Divider(
                  color: appTheme.onSurface.withOpacity(0.4),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  s.or_continue_with,
                  style: appTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: appTheme.textTheme.bodySmall?.color?.withOpacity(
                      0.8,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: appTheme.onSurface.withOpacity(0.4),
                  thickness: 1,
                ),
              ),
            ],
          ),
          AppGaps.h24,

          // Google Sign-In
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: controller.googleSignIn,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: appTheme.onSurface.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: appTheme.onSurface.withOpacity(0.08),
              ),
              icon: Image.asset(AppImages.logoGoogle, height: 24, width: 24),
              label: Text(
                s.sign_in_with_google,
                style: appTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
          AppGaps.h24,

          // Sign Up Link
          buildAuthNavigation(
            context: context,
            text: s.dont_have_account,
            actionText: s.sign_up,
            onTap: controller.goToRegister,
          ),
        ],
      ),
    );
  }
}
