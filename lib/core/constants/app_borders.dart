import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppBorders {
  // Button radius
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radius14 = BorderRadius.all(Radius.circular(14));

  // Input borders
  static OutlineInputBorder inputBorder({
    Color color = AppColors.primary,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: radius14,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static OutlineInputBorder focusedInputBorder({
    Color color = AppColors.primaryLight,
    double width = 1.2,
  }) {
    return OutlineInputBorder(
      borderRadius: radius14,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static OutlineInputBorder enabledInputBorder({
    Color color = AppColors.textFaintLight,
    double width = 0.8,
  }) {
    return OutlineInputBorder(
      borderRadius: radius14,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  AppBorders._();
}
