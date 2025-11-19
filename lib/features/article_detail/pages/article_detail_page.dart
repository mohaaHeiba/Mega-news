import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';
import 'package:mega_news/features/article_detail/widgets/build_article_view.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class ArticleDetailPage extends GetView<ArticleDetailController> {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context;
    final data = Get.arguments as Article;

    // final bool isSummaryMode = article == null;

    return buildArticleView(context, theme, controller, data);

    // if (isSummaryMode) {
    // } else {
    //   return buildArticleView(context, theme, controller, article);
    // }
  }
}
