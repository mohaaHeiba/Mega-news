import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';
import 'package:mega_news/features/auth/presentations/pages/create_new_password_page.dart';
import 'package:mega_news/features/auth/presentations/pages/forgot_password_page.dart';
import 'package:mega_news/features/auth/presentations/pages/login_page.dart';
import 'package:mega_news/features/auth/presentations/pages/register_page.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: context.screenHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. زر الزائر
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: controller.loginGuest,
                    style: TextButton.styleFrom(
                      // 2. لون النص والأيقونة يتغير حسب الخلفية
                      foregroundColor: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    icon: const Icon(Icons.person_outline_rounded, size: 20),
                    label: const Text('Guest'),
                  ),
                ),

                AppGaps.h24,

                // 2. العنوان والترحيب
                Obx(() {
                  String title;
                  String subtitle;

                  switch (controller.currentPageIndex.value) {
                    case 0: // Login
                      title = "Let's sign you in.";
                      subtitle = "Welcome back.\nYou've been missed!";
                      break;
                    case 1: // Register
                      title = "Create an account.";
                      subtitle =
                          "Join us & start exploring\nall the breaking news.";
                      break;
                    case 2: // Forgot Password
                      title = "Forgot Password?";
                      subtitle =
                          "Don't worry! It happens.\nPlease enter your email.";
                      break;
                    case 3: // Create Password
                      title = "New Password";
                      subtitle =
                          "Your new password must be different\nfrom previously used passwords.";
                      break;
                    default:
                      title = "Welcome";
                      subtitle = "";
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          // 3. النص الأساسي يأخذ لون "فوق السطح" (أسود/أبيض)
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      AppGaps.h12,
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          // 4. النص الفرعي يكون باهتاً قليلاً ليعطي إيحاء الرمادي
                          color: colorScheme.onSurface.withOpacity(0.6),
                          height: 1.5,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }),

                AppGaps.h32,
                Form(
                  key: controller.formKey,
                  child: Obx(() {
                    switch (controller.currentPageIndex.value) {
                      case 0:
                        return const LoginPage();
                      case 1:
                        return const RegisterPage();
                      case 2:
                        return const ForgotPasswordPage();
                      case 3:
                        return const CreateNewPasswordPage();
                      default:
                        return const LoginPage();
                    }
                  }),
                ),

                AppGaps.h32,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
