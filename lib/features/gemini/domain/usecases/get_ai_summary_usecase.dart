import 'package:get/get.dart';
import 'package:mega_news/features/gemini/domain/repositories/i_gemini_repository.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class GetAiSummaryUseCase {
  final IGeminiRepository _repository;

  GetAiSummaryUseCase(this._repository);

  // ============================================================
  // 1. Search
  // ============================================================
  Future<String> call({
    required String topic,
    required List<Article> articles,
  }) async {
    final currentLanguage = Get.locale?.languageCode ?? 'en';
    final isArabic = currentLanguage == 'ar';

    final systemPrompt = isArabic
        ? 'أنت خبير في تلخيص الأخبار...'
        : 'You are an expert in news summarization...';

    final articlesContent = articles
        .map(
          (a) => isArabic
              ? 'المصدر: ${a.sourceName}\nالعنوان: ${a.title}'
              : 'Source: ${a.sourceName}\nTitle: ${a.title}',
        )
        .join('\n');

    final userQuery = isArabic
        ? 'الموضوع: "$topic".\nالمقالات:\n$articlesContent\n...'
        : 'Topic: "$topic".\nArticles:\n$articlesContent\n...';

    return await _repository.generateText('$systemPrompt\n\n$userQuery');
  }

  // ============================================================
  // 2.AI Briefing
  // ============================================================
  Future<String> callDualLang({
    required String topic,
    required List<Article> articles,
  }) async {
    final articlesContent = articles
        .map((a) => 'Source: ${a.sourceName} - Title: ${a.title}')
        .join('\n');

    const separator = "###SPLIT###";

    final prompt =
        '''
    You are an expert news assistant. 
    Topic: "$topic"
    Articles:
    $articlesContent

    Task:
    1. Write a short summary in **ENGLISH** mentioning key sources.
    2. Write exactly "$separator".
    3. Write a short summary in **ARABIC** mentioning key sources.
    ''';

    return await _repository.generateText(prompt);
  }
}
