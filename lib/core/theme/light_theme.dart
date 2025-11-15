import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_borders.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/constants/app_text_styles.dart';

class LightTheme {
  static final ThemeData theme = ThemeData(
    // ================== General ==================
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.error,
    ),

    cardColor: AppColors.lightSurface,
    dialogBackgroundColor: AppColors.lightOverlay,

    // ================== Text =====================
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLargeLight,
      headlineMedium: AppTextStyles.headlineMediumLight,
      bodyLarge: AppTextStyles.bodyLargeLight,
      bodyMedium: AppTextStyles.bodyMediumLight,
      labelSmall: AppTextStyles.labelSmallLight,
    ),

    // ================== Buttons ==================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppBorders.radius16),
        shadowColor: AppColors.primary.withOpacity(0.2),
        elevation: 5,
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
      fillColor: AppColors.lightOverlay,
      hintStyle: const TextStyle(color: AppColors.textFaintLight, fontSize: 14),
      labelStyle: const TextStyle(
        color: AppColors.textFaint,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      border: AppBorders.inputBorder(),
      focusedBorder: AppBorders.focusedInputBorder(
        color: AppColors.primaryDark,
      ),
      enabledBorder: AppBorders.enabledInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
