import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme {
  static ThemeData getDarkTheme() => DarkTheme.theme;
  static ThemeData getLightTheme() => LightTheme.theme;
}
