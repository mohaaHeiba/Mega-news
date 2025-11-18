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

      if (page > 1) {
        queryParams['page'] = page.toString();
      }

      print('🔹 GNews Search Query Params: $queryParams');

      final responseData = await apiClient.get(
        '$_baseUrl/search',
        queryParameters: queryParams,
      );

      print('🔹 GNews Search Response: $responseData');

      if (responseData is! Map<String, dynamic>) {
        throw UnknownException(
          message: 'Invalid response format from GNews API',
        );
      }

      final model = GnewsResponseModel.fromJson(responseData);

      print('🔹 Parsed Articles Count: ${model.articles.length}');

      return model.articles;
    } on ApiException {
      rethrow;
    } catch (e) {
      print('❌ Error in searchNews: $e');
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
        'topic': category,
        'max': '20',
      };

      if (page > 1) {
        queryParams['page'] = page.toString();
      }

      print('🔹 GNews TopHeadlines Query Params: $queryParams');

      final responseData = await apiClient.get(
        '$_baseUrl/top-headlines',
        queryParameters: queryParams,
      );

      print('🔹 GNews TopHeadlines Response: $responseData');

      if (responseData is! Map<String, dynamic>) {
        throw UnknownException(
          message: 'Invalid response format from GNews API',
        );
      }

      final model = GnewsResponseModel.fromJson(responseData);

      print('🔹 Parsed TopHeadlines Articles Count: ${model.articles.length}');

      return model.articles;
    } on ApiException {
      rethrow;
    } catch (e) {
      print('❌ Error in getTopHeadlines: $e');
      throw UnknownException(
        message: 'Failed to parse GNews headlines response: $e',
      );
    }
  }
}
