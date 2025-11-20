import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

class EmailVerificationPage extends GetView<AuthController> {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments;
    final s = context.s;
    final appTheme = context;

    return Scaffold(
      body: Container(
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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: appTheme.primary),
                  AppGaps.h24,

                  // Verification message
                  Text(
                    '${s.emailVerificationMessage} $email',
                    textAlign: TextAlign.center,
                    style: appTheme.textTheme.bodyLarge?.copyWith(
                      color: appTheme.onBackground,
                    ),
                  ),
                  AppGaps.h12,

                  // Instruction text
                  Text(
                    '${s.emailVerificationInstruction} $email',
                    textAlign: TextAlign.center,
                    style: appTheme.textTheme.bodyMedium?.copyWith(
                      color: appTheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
