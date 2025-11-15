import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_borders.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/constants/app_text_styles.dart';

class DarkTheme {
  static final ThemeData theme = ThemeData(
    // ================== General ==================
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
    ),
    cardColor: AppColors.surface,
    dialogBackgroundColor: AppColors.overlay,

    // ================== Text =====================
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    // ================== Buttons ==================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: AppBorders.radius16),
        shadowColor: AppColors.primary.withOpacity(0.25),
        elevation: 8,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    ),

    // ================== TextFields ==================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.overlay,
      hintStyle: const TextStyle(color: AppColors.textFaint),
      border: AppBorders.inputBorder(),
      focusedBorder: AppBorders.focusedInputBorder(),
      enabledBorder: AppBorders.enabledInputBorder(),
    ),
  );
}
