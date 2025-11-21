import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/search/controller/search_controller.dart';

Widget buildFloatingActionButton(
  BuildContext context,
  SearchController controller,
) {
  return Obx(() {
    if (controller.articles.isNotEmpty &&
        !controller.isLoading.value &&
        !controller.isSummarizing.value) {
      return FloatingActionButton.extended(
        onPressed: () => controller.summarizeSearchResults(),
        backgroundColor: context.primary,
        foregroundColor: Colors.white,
        label: const Text('Summarize Results'),
        icon: const Icon(Icons.auto_awesome_rounded),
        elevation: 4,
      );
    } else if (controller.isSummarizing.value) {
      return FloatingActionButton(
        onPressed: () {},
        backgroundColor: context.surface,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  });
}
