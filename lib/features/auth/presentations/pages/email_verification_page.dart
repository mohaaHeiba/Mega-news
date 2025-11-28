import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

class EmailVerificationPage extends GetView<AuthController> {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments as String;
    final s = context.s;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: DecoratedBox(
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

          // Header Icon
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: context.screenHeight * 0.35,
            child: SafeArea(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mark_email_read_rounded,
                      color: Colors.white,
                      size: 72,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: context.screenHeight * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Title
                    Text(
                      s.emailVerificationMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    AppGaps.h16,

                    // Instructions
                    Text(
                      s.emailVerificationInstruction,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),

                    AppGaps.h32,

                    // Email Display Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Verification email sent to",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                          AppGaps.h8,
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppGaps.h32,

                    // Waiting indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              "Waiting for verification...",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppGaps.h32,

                    // Resend Button
                    TextButton.icon(
                      onPressed: () {
                        // Add resend logic here
                      },
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      label: Text(
                        "Resend verification email",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    AppGaps.h16,

                    // Help text
                    Text(
                      "Check your spam folder if you don't see the email",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
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
