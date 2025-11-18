import 'package:mega_news/features/news/domain/entities/article.dart';

abstract class INewsRepository {
  Future<List<Article>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  });

  Future<List<Article>> searchNews(
    String query, {
    String? language,
    int page = 1,
  });
}
