import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mega_news/core/errors/api_exception.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/features/news/data/model/newsapi_response_model.dart';

abstract class INewsApiRemoteDataSource {
  Future<List<NewsApiArticleModel>> searchNews(
    String query, {
    String? language,
    int page = 1,
  });

  Future<List<NewsApiArticleModel>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  });
}

class NewsApiRemoteDataSourceImpl implements INewsApiRemoteDataSource {
  final ApiClient apiClient;

  final String _apiKey = dotenv.env['NEWS_API']!;
  final String _baseUrl = 'https://newsapi.org/v2';

  NewsApiRemoteDataSourceImpl({required this.apiClient});

  // ----------------------------------------------------------------------
  // SEARCH EVERYTHING
  // ----------------------------------------------------------------------
  @override
  Future<List<NewsApiArticleModel>> searchNews(
    String query, {
    String? language,
    int page = 1,
  }) async {
    try {
      // final lang = language ?? 'ar';

      final queryParams = <String, dynamic>{
        'q': query,
        'language': 'ar',
        'apiKey': _apiKey,
        'page': page.toString(),
        'pageSize': '20',
      };

      final response = await apiClient.get(
        '$_baseUrl/everything',
        queryParameters: queryParams,
      );

      final model = NewsapiResponseModel.fromJson(response);

      return model.articles;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse NewsAPI search response: $e',
      );
    }
  }

  // ----------------------------------------------------------------------
  // TOP HEADLINES (CATEGORY) بالعربي
  // ----------------------------------------------------------------------
  @override
  Future<List<NewsApiArticleModel>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  }) async {
    try {
      final lang = language ?? 'ar';

      final queryParams = <String, dynamic>{
        'category': category,
        'language': lang,
        'apiKey': _apiKey,
        'page': page.toString(),
        'pageSize': '20',
      };

      final response = await apiClient.get(
        '$_baseUrl/top-headlines',
        queryParameters: queryParams,
      );

      final model = NewsapiResponseModel.fromJson(response);

      for (var article in model.articles) {
        print('${article.title} - ${article.source.name}');
      }

      return model.articles;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse NewsAPI headlines response: $e',
      );
    }
  }
}
