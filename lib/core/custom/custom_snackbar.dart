import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController customSnackbar({
  required String title,
  required String message,
  Color? color,
  SnackPosition position = SnackPosition.TOP,
  Duration duration = const Duration(seconds: 3),
}) {
  return Get.showSnackbar(
    GetSnackBar(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      messageText: Text(
        message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
      ),
      backgroundColor: color ?? Colors.green,
      snackPosition: position,
      duration: duration,
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.linearToEaseOut,
      boxShadows: [
        BoxShadow(
          color: (color ?? Colors.green).withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    ),
  );
}
