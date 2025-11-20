import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/search/presentations/controller/search_controller.dart';

Widget buildSearchBar(BuildContext context, SearchController controller) {
  return Container(
    height: 56,
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: context.onBackground.withOpacity(0.05),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Icon(Icons.search_rounded, color: context.primary, size: 26),
        ),
        Expanded(
          child: TextField(
            controller: controller.textController,
            style: TextStyle(
              fontSize: 16,
              color: context.onBackground,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Search news, topics...',
              hintStyle: TextStyle(
                color: context.onBackground.withOpacity(0.4),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        Obx(
          () => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: context.onBackground.withOpacity(0.6),
                    size: 20,
                  ),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink(),
        ),
        Container(
          height: 32,
          width: 1,
          color: context.onBackground.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(horizontal: 4),
        ),
        IconButton(
          icon: Icon(
            Icons.mic_none_rounded,
            color: context.onBackground.withOpacity(0.6),
            size: 26,
          ),
          onPressed: controller.startListening,
        ),
        const SizedBox(width: 4),
      ],
    ),
  );
}
