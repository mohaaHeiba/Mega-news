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

    // للحصول على ارتفاع الكيبورد
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      // 1. منع تغيير حجم الصفحة عند فتح الكيبورد
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. الخلفية الثابتة
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // 2. الهيدر المتغير (النصوص والأيقونات)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: context.screenHeight * 0.35,
            child: SafeArea(
              child: Center(
                child: Obx(() {
                  final index = controller.currentPageIndex.value;

                  IconData icon;
                  String title;
                  String subtitle;

                  switch (index) {
                    case 0: // Login
                      icon = Icons.newspaper_rounded;
                      title = s.welcome_back;
                      subtitle = s.login_to_continue;
                      break;
                    case 1: // Register
                      icon = Icons.person_add_rounded;
                      title = s.registerTitle;
                      subtitle = s.registerSubtitle;
                      break;
                    case 2: // Forgot Password
                      icon = Icons.lock_reset_rounded;
                      title = s.forgotPasswordTitle;
                      subtitle = s.forgotPasswordSubtitle;
                      break;
                    case 3: // Create Password
                      icon = Icons.lock_outline_rounded;
                      title = s.create;
                      subtitle = s.set_strong_password;
                      break;
                    default:
                      icon = Icons.newspaper_rounded;
                      title = "";
                      subtitle = "";
                  }

                  return Padding(
                    // إضافة مسافة جانبية للنصوص عشان متلزقش في الحواف
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            icon,
                            key: ValueKey<int>(index),
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        AppGaps.h12,
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            title,
                            key: ValueKey<String>(title),
                            textAlign:
                                TextAlign.center, // محاذاة النص في المنتصف
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AppGaps.h4,
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            subtitle,
                            key: ValueKey<String>(subtitle),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          // 3. زر الزائر
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: controller.loginGuest,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Guest',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. البطاقة البيضاء (Sheet) + المحتوى
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              // 2. تثبيت الارتفاع ليكون 70% لإعطاء مساحة للهيدر
              height: context.screenHeight * 0.70,
              // 3. إضافة padding سفلي بقيمة ارتفاع الكيبورد للسماح بالسكرول
              padding: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0,
                bottom: bottomPadding, // هذا هو السر
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: Form(
                  key: controller.formKey,
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
