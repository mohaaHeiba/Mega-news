import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';
import 'package:mega_news/features/article_detail/widgets/build_ai_view.dart';
import 'package:mega_news/features/article_detail/widgets/build_normal_article_view.dart';
import 'package:mega_news/features/article_detail/widgets/button_article_link.dart';

class ArticleDetailPage extends GetView<ArticleDetailController> {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;

    final bool isAiMode = controller.aiSummary != null;

    return Scaffold(
      backgroundColor: theme.surface,

      bottomNavigationBar: isAiMode
          ? null
          : buttonArticleLink(theme, controller),

      body: Obx(() {
        final dynamicColor = controller.vibrantColor.value;

        if (isAiMode) {
          return buildAiView(theme, dynamicColor, controller);
        }

        return buildNormalArticleView(theme, dynamicColor, controller);
      }),
    );
  }
}
