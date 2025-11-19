import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/gemini/domain/usecases/get_ai_summary_usecase.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';

class AiBriefingController extends GetxController {
  final INewsRepository newsRepository;
  final GetAiSummaryUseCase getAiSummaryUseCase;

  AiBriefingController({
    required this.newsRepository,
    required this.getAiSummaryUseCase,
  });

  // Key: topic value (e.g., 'sports'), Value: The Article object
  final RxMap<String, Article> cachedSummaries = <String, Article>{}.obs;

  final RxSet<String> loadingTopicIds = <String>{}.obs;

  // --- Static Topics Data ---
  List<Map<String, String>> get staticTopics {
    final s = Get.context?.s;
    return [
      {
        'label': s?.general ?? 'General',
        'value': 'general',
        'image': AppImages.general,
      },
      {
        'label': s?.sports ?? 'Sports',
        'value': 'sports',
        'image': AppImages.sports,
      },
      {
        'label': s?.technology ?? 'Technology',
        'value': 'technology',
        'image': AppImages.technology,
      },
      {
        'label': s?.business ?? 'Business',
        'value': 'business',
        'image': AppImages.business,
      },
      {
        'label': s?.health ?? 'Health',
        'value': 'health',
        'image': AppImages.health,
      },
      {
        'label': s?.science ?? 'Science',
        'value': 'science',
        'image': AppImages.science,
      },
    ];
  }

  /// Main Action: Handles selection, caching, and refreshing
  Future<void> selectAndSummarizeTopic(
    Map<String, String> topic, {
    bool forceRefresh = false,
  }) async {
    final topicId = topic['value']!;

    // 1. for spam
    if (loadingTopicIds.contains(topicId)) return;

    // 2. Check Cache:
    if (!forceRefresh && cachedSummaries.containsKey(topicId)) {
      Get.toNamed(
        AppPages.articleDetailPage,
        arguments: cachedSummaries[topicId],
      );
      return;
    }

    // 3. Start Loading:
    loadingTopicIds.add(topicId);

    try {
      final Article result = await _fetchAndSummarizeTopic(topic);

      // 4. Save to Cache:
      cachedSummaries[topicId] = result;

      loadingTopicIds.remove(topicId);

      Get.toNamed(AppPages.articleDetailPage, arguments: result);
    } catch (e) {
      loadingTopicIds.remove(topicId);
      Get.snackbar(
        "Generation Failed",
        'Could not generate summary. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<Article> _fetchAndSummarizeTopic(Map<String, String> topic) async {
    final label = topic['label']!;
    final value = topic['value']!;
    final fixedImage = topic['image']!;

    String summaryText = "";
    String articleUrl = "https://news.google.com";

    try {
      final articles = await newsRepository.getTopHeadlines(category: value);

      if (articles.isNotEmpty) {
        articleUrl = articles.first.articleUrl;
        summaryText = await getAiSummaryUseCase(
          topic: label,
          articles: articles.take(5).toList(),
        );
      } else {
        summaryText = "No recent news found for $label to summarize.";
      }
    } catch (e) {
      summaryText = "Could not generate summary due to an error.";
    }

    return Article(
      id: value,
      sourceName: "AI Briefing",
      title: label,
      description: summaryText,
      articleUrl: articleUrl,
      imageUrl: fixedImage,
      publishedAt: DateTime.now(),
    );
  }
}
