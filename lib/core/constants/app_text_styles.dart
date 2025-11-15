import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display / Headings
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.5,
    color: AppColors.textPrimary, // Dark mode by default
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    color: AppColors.textFaint,
  );

  // Light mode versions
  static const TextStyle displayLargeLight = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.5,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headlineMediumLight = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodyLargeLight = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondaryLight,
  );

  static const TextStyle bodyMediumLight = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondaryLight,
  );

  static const TextStyle labelSmallLight = TextStyle(
    fontSize: 12,
    color: AppColors.textFaintLight,
  );

  AppTextStyles._();
}
