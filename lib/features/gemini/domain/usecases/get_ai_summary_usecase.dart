import 'package:get/get.dart';
import 'package:mega_news/features/gemini/domain/repositories/i_gemini_repository.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class GetAiSummaryUseCase {
  final IGeminiRepository _repository;

  GetAiSummaryUseCase(this._repository);

  // ============================================================
  // 1. Search Summary (تم التعديل هنا)
  // ============================================================
  Future<String> call({
    required String topic,
    required List<Article> articles,
  }) async {
    final currentLanguage = Get.locale?.languageCode ?? 'en';
    final isArabic = currentLanguage == 'ar';

    // 1. تجهيز محتوى المقالات
    final articlesContent = articles
        .map(
          (a) => isArabic
              ? '- المصدر: ${a.sourceName} | العنوان: ${a.title}'
              : '- Source: ${a.sourceName} | Title: ${a.title}',
        )
        .join('\n');

    // 2. تعليمات النظام (System Prompt) - معدلة لتكون صارمة
    final prompt = isArabic
        ? '''
أنت مساعد ذكي لتلخيص الأخبار.
المهمة: لخص المقالات التالية حول موضوع "$topic" في فقرة واحدة مركزة.

تعليمات صارمة:
1. ابدأ الملخص مباشرة. لا تكتب مقدمات مثل "إليك الملخص" أو "بناءً على ما سبق".
2. لا تكرر نص التعليمات أو أسماء المقالات في البداية.
3. اكتفِ بالمعلومات المهمة فقط.

المقالات:
$articlesContent
'''
        : '''
You are an AI news summarizer.
Task: Summarize the following articles about "$topic" into a single focused paragraph.

Strict Instructions:
1. Start the summary DIRECTLY. Do not say "Here is the summary" or "Based on the articles".
2. Do NOT repeat the prompt or the instructions.
3. Focus only on key insights.

Articles:
$articlesContent
''';

    // إرسال الـ Prompt مباشرة (دمجنا التعليمات مع الداتا لتقليل اللخبطة)
    return await _repository.generateText(prompt);
  }

  // ============================================================
  // 2. AI Briefing (Dual Language)
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
    1. Write a short summary in **ENGLISH**.
    2. Write exactly "$separator".
    3. Write a short summary in **ARABIC**.
    
    Constraint: Output ONLY the requested format. Do not add conversational text.
    ''';

    return await _repository.generateText(prompt);
  }
}
