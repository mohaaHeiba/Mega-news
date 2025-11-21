import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/custom/custom_snackbar.dart';
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

  // ==================================================
  // Main Action
  // ==================================================
  Future<void> selectAndSummarizeTopic(
    Map<String, String> topic, {
    bool forceRefresh = false,
  }) async {
    final topicId = topic['value']!;

    if (loadingTopicIds.contains(topicId)) return;

    final cachedArticle = cachedSummaries[topicId];
    if (!forceRefresh && cachedArticle != null) {
      _navigateToDetails(cachedArticle);
      return;
    }

    loadingTopicIds.add(topicId);

    try {
      final Article result = await _fetchAndSummarizeTopic(topic);

      cachedSummaries[topicId] = result;

      loadingTopicIds.remove(topicId);

      _navigateToDetails(result);
    } catch (e) {
      loadingTopicIds.remove(topicId);
      customSnackbar(
        title: s.generation_failed_title,
        message: s.generation_failed_msg,
        color: AppColors.error,
      );
    }
  }

  // ==================================================
  //
  // ==================================================

  void _navigateToDetails(Article fullArticle) {
    final isArabic = Get.locale?.languageCode == 'ar';
    String finalDescription = fullArticle.description ?? '';

    const separator = "###SPLIT###";
    if (finalDescription.contains(separator)) {
      final parts = finalDescription.split(separator);
      if (parts.length >= 2) {
        finalDescription = isArabic ? parts[1].trim() : parts[0].trim();
      }
    }

    final String uniqueId =
        'ai_briefing_${fullArticle.title}_${DateTime.now().millisecondsSinceEpoch}';

    final articleToShow = Article(
      id: uniqueId,
      sourceName: "AI Briefing",
      author: "Gemini AI",
      title: fullArticle.title,
      description: finalDescription,
      articleUrl: fullArticle.articleUrl,
      imageUrl: fullArticle.imageUrl,
      publishedAt: DateTime.now(),
    );

    Get.toNamed(AppPages.articleDetailPage, arguments: articleToShow);
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

        summaryText = await getAiSummaryUseCase.callDualLang(
          topic: label,
          articles: articles.take(10).toList(),
        );
      } else {
        summaryText = "${s.ai_summary_error} ###SPLIT### ${s.ai_summary_error}";
      }
    } catch (e) {
      summaryText = "${s.ai_summary_error} ###SPLIT### ${s.ai_summary_error}";
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
