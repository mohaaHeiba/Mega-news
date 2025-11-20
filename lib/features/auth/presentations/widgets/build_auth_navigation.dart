import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';

Widget buildAuthNavigation({
  required BuildContext context,
  required String text,
  required String actionText,
  required VoidCallback onTap,
}) {
  return Center(
    child: GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: text,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          children: [
            const WidgetSpan(child: AppGaps.h4),
            TextSpan(
              text: actionText,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: context.primary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
