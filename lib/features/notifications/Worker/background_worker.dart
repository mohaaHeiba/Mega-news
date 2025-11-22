import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/core/services/notification_service.dart';
import 'package:mega_news/features/gemini/data/datasources/gemini_remote_datasource.dart';
import 'package:mega_news/features/gemini/data/repositories/gemini_repository_impl.dart';
import 'package:mega_news/features/gemini/domain/usecases/get_ai_summary_usecase.dart';
import 'package:mega_news/features/news/data/datasources/currents_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/gnews_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/newsapi_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/newsdata_remote_datasource.dart';
import 'package:mega_news/features/news/data/mappers/article_mapper.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/news_repository_impl.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await dotenv.load(fileName: ".env");

      // تهيئة Gemini
      Gemini.init(apiKey: dotenv.env['GEMINI_API']!);

      // 2. استلام البيانات
      final topic = inputData?['topic'] ?? 'General';
      final lang = inputData?['lang'] ?? 'en';

      // 3. بناء الـ Repositories
      final dio = Dio();
      final apiClient = ApiClient(dio);
      final mapper = ArticleMapper();

      final gNews = GNewsRemoteDataSourceImpl(apiClient: apiClient);
      final newsApi = NewsApiRemoteDataSourceImpl(apiClient: apiClient);
      final newsData = NewsDataRemoteDataSourceImpl(apiClient: apiClient);
      final currents = CurrentsRemoteDataSourceImpl(
        dio: dio,
        articleMapper: mapper,
      );

      final newsRepository = NewsRepositoryImpl(
        gNewsSource: gNews,
        newsApiSource: newsApi,
        newsDataSource: newsData,
        currentsSource: currents,
        mapper: mapper,
      );

      final geminiDataSource = GeminiRemoteDataSourceImpl(Gemini.instance);
      final geminiRepository = GeminiRepositoryImpl(geminiDataSource);
      final getAiSummaryUseCase = GetAiSummaryUseCase(geminiRepository);

      final articles = await newsRepository.searchNews(
        topic,
        language: lang,
        page: 1,
      );

      if (articles.isNotEmpty) {
        // 5. التلخيص
        final summary = await getAiSummaryUseCase(
          topic: topic,
          articles: articles,
        );

        // 6. تجهيز المقال
        final String mainImage =
            articles
                .firstWhere(
                  (e) => e.imageUrl != null && e.imageUrl!.isNotEmpty,
                  orElse: () => articles.first,
                )
                .imageUrl ??
            '';

        final aiArticle = Article(
          id: "ai_${DateTime.now().millisecondsSinceEpoch}",
          sourceName: "AI Assistant",
          author: "Gemini",
          title: "ملخص ذكي: $topic",
          description: summary,
          articleUrl: "https://google.com/search?q=$topic",
          imageUrl: mainImage,
          publishedAt: DateTime.now(),
          content: summary,
        );

        // 7. تجهيز البيانات للإرسال
        final articleMap = {
          'id': aiArticle.id,
          'title': aiArticle.title,
          'description': aiArticle.description,
          'imageUrl': aiArticle.imageUrl,
          'sourceName': aiArticle.sourceName,
          'articleUrl': aiArticle.articleUrl,
          'publishedAt': aiArticle.publishedAt.toIso8601String(),
          'content': aiArticle.content,
          'author': aiArticle.author,
        };

        // ==========================================================
        // ✅ التعديل الأهم: تحويل الـ Map لنص JSON
        // ==========================================================
        final String jsonPayload = jsonEncode(articleMap);

        // 8. إرسال الإشعار مع البيانات الكاملة
        await NotificationService.init();

        await NotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: "ملخصك جاهز عن $topic 🧠",
          body: "اضغط لقراءة ملخص الأحداث الذي أعده الذكاء الاصطناعي لك.",
          imageUrl: mainImage,
          payload: jsonPayload,
        );
      }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}
