import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mega_news/core/errors/api_exception.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/features/news/data/model/gnews_response_model.dart';

abstract class IGNewsRemoteDataSource {
  Future<List<GNewsArticleModel>> searchNews(
    String query, {
    String? language,
    int page = 1,
  });

  Future<List<GNewsArticleModel>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  });
}

class GNewsRemoteDataSourceImpl implements IGNewsRemoteDataSource {
  final ApiClient apiClient;

  /// DIRECT API KEY (NO VALIDATION / NO LOGGER)
  final String _apiKey = dotenv.env['GNEWS_API']!;

  final String _baseUrl = 'https://gnews.io/api/v4';

  GNewsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<GNewsArticleModel>> searchNews(
    String query, {
    String? language,
    int page = 1,
  }) async {
    try {
      final lang = language ?? 'ar';

      final queryParams = <String, dynamic>{
        'q': query,
        'lang': lang,
        'apikey': _apiKey,
        'max': '20',
      };

      // GNews page starts effectively from page 2
      if (page > 1) {
        queryParams['page'] = page.toString();
      }

      final response = await apiClient.get(
        '$_baseUrl/search',
        queryParameters: queryParams,
      );

      final model = GnewsResponseModel.fromJson(response);
      return model.articles;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse GNews search response: $e',
      );
    }
  }

  @override
  Future<List<GNewsArticleModel>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  }) async {
    try {
      final lang = language ?? 'ar';

      final queryParams = <String, dynamic>{
        'lang': lang,
        'apikey': _apiKey,
        'topic': category, // category mapped to topic
        'max': '20',
      };

      if (page > 1) {
        queryParams['page'] = page.toString();
      }

      final response = await apiClient.get(
        '$_baseUrl/top-headlines',
        queryParameters: queryParams,
      );

      final model = GnewsResponseModel.fromJson(response);
      return model.articles;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse GNews headlines response: $e',
      );
    }
  }
}
