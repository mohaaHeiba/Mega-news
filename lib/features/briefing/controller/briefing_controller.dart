import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/custom/snackbars/custom_snackbar.dart';
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

  final s = Get.context!.s;

  // 1. Caching:
  final RxMap<String, Article> cachedSummaries = <String, Article>{}.obs;

  // 2. Concurrency:
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

    // 1. Check Loading:
    if (loadingTopicIds.contains(topicId)) return;

    // 2. Check Cache Safe Retrieval:
    final cachedArticle = cachedSummaries[topicId];
    if (!forceRefresh && cachedArticle != null) {
      Get.toNamed(AppPages.articleDetailPage, arguments: cachedArticle);
      return;
    }

    // 3. Start Loading
    loadingTopicIds.add(topicId);

    try {
      final Article result = await _fetchAndSummarizeTopic(topic);

      // 4. Save to Cache
      cachedSummaries[topicId] = result;

      loadingTopicIds.remove(topicId);

      Get.toNamed(AppPages.articleDetailPage, arguments: result);
    } catch (e) {
      loadingTopicIds.remove(topicId);

      customSnackbar(
        title: s.generation_failed_title,
        message: s.generation_failed_msg,
        color: AppColors.error,
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
        summaryText = s.ai_summary_error;
      }
    } catch (e) {
      summaryText = s.ai_summary_error;
    }

    return Article(
      id: value,
      sourceName: s.ai_briefing,
      title: label,
      description: summaryText,
      articleUrl: articleUrl,
      imageUrl: fixedImage,
      publishedAt: DateTime.now(),
    );
  }
}
