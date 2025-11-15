import 'package:flutter/material.dart';
import 'package:mega_news/core/helper/context_extensions.dart';

class Validator {
  //name
  static String? name(BuildContext context, String value) {
    final s = context.s;
    if (value.isEmpty) return s.enterName;
    if (value.length < 3) return s.nameMinChars;
    return null;
  }

  //email
  static String? email(BuildContext context, String value) {
    final s = context.s;
    if (value.isEmpty) return s.enterEmail;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return s.invalidEmail;

    return null;
  }

  //password
  static String? password(BuildContext context, String value) {
    final s = context.s;
    if (value.isEmpty) return s.enterPassword;
    if (value.length < 6) return s.passwordMinChars;

    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return s.passwordUpperNumber;
    }

    return null;
  }

  //confirm password
  static String? confirmPassword(
    BuildContext context,
    String password,
    String confirmPassword,
  ) {
    final s = context.s;
    if (confirmPassword.isEmpty) return s.confirmPassword;
    if (password != confirmPassword) return s.passwordsNotMatch;
    return null;
  }
}
