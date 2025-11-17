import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';
import 'package:mega_news/features/auth/presentations/pages/create_new_password_page.dart';
import 'package:mega_news/features/auth/presentations/pages/forgot_password_page.dart';
import 'package:mega_news/features/auth/presentations/pages/login_page.dart';
import 'package:mega_news/features/auth/presentations/pages/register_page.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context;
    return Scaffold(
      backgroundColor: appTheme.background,

      // AppBar contains Guest button only
      appBar: AppBar(
        backgroundColor: appTheme.primary.withOpacity(0.5),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () async {
                await GetStorage().write('loginBefore', true);

                Get.offAllNamed(AppPages.layoutPage);
              },
              icon: Icon(Icons.person_outline, color: appTheme.primary),
              label: Text(
                'Guest',
                style: appTheme.textTheme.titleMedium?.copyWith(
                  color: appTheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Form(
        key: controller.formKey,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: const [
            LoginPage(),
            RegisterPage(),
            ForgotPasswordPage(),
            CreateNewPasswordPage(),
          ],
        ),
      ),
    );
  }
}
