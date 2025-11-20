import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

Widget buildSubmitButton({
  required BuildContext context,
  required AuthController controller,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 54,
    child: Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: context.primary),
        onPressed: controller.isLoading.value ? null : onPressed,
        child: controller.isLoading.value
            ? CircularProgressIndicator(color: context.onPrimary)
            : Text(
                buttonText,
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    ),
  );
}
