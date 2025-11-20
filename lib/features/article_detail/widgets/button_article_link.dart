import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';

Widget buttonArticleLink(
  BuildContext context,
  ArticleDetailController controller,
) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      color: context.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: SafeArea(
      child: Obx(() {
        final dynamicColor = controller.vibrantColor.value != Colors.transparent
            ? controller.vibrantColor.value
            : Colors.transparent;

        return SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(
              context.s.action_read_full_story,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: dynamicColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: controller.openArticleLink,
          ),
        );
      }),
    ),
  );
}
