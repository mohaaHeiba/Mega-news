import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/search/controller/search_controller.dart';

Widget buildSearchBar(BuildContext context, SearchController controller) {
  return Obx(() {
    final isEmpty = controller.searchQuery.value.isEmpty;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),

          // 🔍 زرار Search
          Icon(
            Icons.search_rounded,
            color: context.onBackground.withOpacity(0.7),
            size: 22,
          ),

          // ✏️ TextField
          Expanded(
            child: TextField(
              controller: controller.textController,
              cursorColor: context.primary,
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                hintText: context.s.search_hint,
                hintStyle: context.textStyles.bodyMedium?.copyWith(
                  color: context.onBackground.withOpacity(0.45),
                  fontSize: 16,
                ),

                // 🔥 إزالة أي Border نهائياً
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,

                // 🎨 جعل الخلفية نفس surface
                filled: true,
                fillColor: context.surface,

                isDense: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // ❌ Clear Button (لما يكون في نص)
          if (!isEmpty)
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: context.onBackground.withOpacity(0.7),
                size: 20,
              ),
              onPressed: controller.clearSearch,
            ),

          const SizedBox(width: 4),
        ],
      ),
    );
  });
}
