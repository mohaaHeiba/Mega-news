import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

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
          AppGaps.h40,

          // Email Field
          textFieldWidget(
            controller: controller.emailController,
            label: s.email,
            hint: s.enter_email,
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            validator: (value) => validator.validateEmail(value ?? ''),
          ),
          AppGaps.h16,

          // Password Field
          textFieldPasswordWidget(
            controller: controller.passController,
            label: s.password,
            hint: s.enter_password,
            icon: Icons.lock_outline,
            isObsure: controller.isPasswordObscure,
            validator: (value) => validator.validatePassword(value ?? ''),
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
          SizedBox(
            height: 54,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (controller.formKey.currentState!.validate()) {
                          await controller.signIn(
                            email: controller.emailController.text.trim(),
                            password: controller.passController.text.trim(),
                          );
                        }
                      },
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: appTheme.onPrimary)
                    : Text(
                        s.log_in,
                        style: appTheme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          AppGaps.h32,

          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: appTheme.background.withOpacity(0.4),
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
                  color: appTheme.background.withOpacity(0.4),
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
                side: BorderSide(color: appTheme.background.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: appTheme.surface.withOpacity(0.08),
              ),
              icon: Image.asset(
                'assets/images/logo_google.png',
                height: 24,
                width: 24,
              ),
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
          Center(
            child: GestureDetector(
              onTap: controller.goToRegister,
              child: RichText(
                text: TextSpan(
                  text: s.dont_have_account,
                  style: appTheme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.textTheme.bodyMedium?.color?.withOpacity(
                      0.85,
                    ),
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: s.sign_up,
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
    );
  }
}
