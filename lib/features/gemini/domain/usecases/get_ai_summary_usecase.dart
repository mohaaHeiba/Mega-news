import 'package:get/get.dart';
import 'package:mega_news/features/gemini/domain/repositories/i_gemini_repository.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class GetAiSummaryUseCase {
  final IGeminiRepository _repository;

  GetAiSummaryUseCase(this._repository);

  Future<String> call({
    required String topic,
    required List<Article> articles,
  }) async {
    final currentLanguage = Get.locale?.languageCode ?? 'en';
    final isArabic = currentLanguage == 'ar';

    final systemPrompt = isArabic
        ? 'أنت خبير في تلخيص الأخبار. مهمتك هي قراءة قائمة من عناوين الأخبار ووصفها، ثم تقديم ملخص من فقرة واحدة (باللغة العربية) لأهم النقاط والأحداث. **ويجب أن تذكر أهم 3-4 مصادر (أسماء المواقع) التي وردت فيها هذه الأخبار في نهاية الملخص.**'
        : 'You are an expert in news summarization. Your task is to read a list of news headlines and descriptions, then provide a one-paragraph summary (in English) of the most important points and events. **You must mention the most important 3-4 sources (website names) that featured these news items at the end of the summary.**';

    final articlesContent = articles
        .map(
          (a) => isArabic
              ? 'المصدر: ${a.sourceName}\nالعنوان: ${a.title}\nالوصف: ${a.description ?? ''}'
              : 'Source: ${a.sourceName}\nTitle: ${a.title}\nDescription: ${a.description ?? ''}',
        )
        .join('\n\n');

    final userQuery = isArabic
        ? 'الموضوع الرئيسي للبحث هو: "$topic".\n\nوهذه هي المقالات التي تم العثور عليها:\n$articlesContent\n\n---\n\nالرجاء تقديم ملخص (باللغة العربية) لهذه النتائج يتضمن أهم المصادر.'
        : 'The main search topic is: "$topic".\n\nThese are the articles that were found:\n$articlesContent\n\n---\n\nPlease provide a summary (in English) of these results including the most important sources.';

    final fullPrompt = '$systemPrompt\n\n$userQuery';

    return await _repository.generateText(fullPrompt);
  }
}
