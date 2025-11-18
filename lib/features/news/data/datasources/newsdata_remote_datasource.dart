import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mega_news/core/errors/api_exception.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/features/news/data/model/newsdata_response_model.dart';

abstract class INewsDataRemoteDataSource {
  Future<List<NewsDataArticleModel>> searchNews(
    String query, {
    String? language,
    int page = 1,
  });

  Future<List<NewsDataArticleModel>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  });
}

class NewsDataRemoteDataSourceImpl implements INewsDataRemoteDataSource {
  final ApiClient apiClient;

  final String _apiKey = dotenv.env['NEWS_DATA']!;
  final String _baseUrl = 'https://newsdata.io/api/1';

  NewsDataRemoteDataSourceImpl({required this.apiClient});

  // ----------------------------------------------------------------------
  // SEARCH NEWS
  // ----------------------------------------------------------------------
  @override
  Future<List<NewsDataArticleModel>> searchNews(
    String query, {
    String? language,
    int page = 1,
  }) async {
    try {
      final lang = language ?? 'ar';

      final queryParams = <String, dynamic>{
        'q': query,
        'language': lang,
        'country': 'eg',
        'apikey': _apiKey,
        if (page > 1) 'page': page.toString(),
      };

      final response = await apiClient.get(
        '$_baseUrl/news',
        queryParameters: queryParams,
      );

      // التأكد من تحويل response.data إذا كان response هو Response من Dio
      final data = response is Map<String, dynamic> ? response : response.data;

      final model = NewsdataResponseModel.fromJson(data);
      return model.results;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse NewsData search response: $e',
      );
    }
  }

  // ----------------------------------------------------------------------
  // TOP HEADLINES
  // ----------------------------------------------------------------------
  @override
  Future<List<NewsDataArticleModel>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  }) async {
    final String apiCategory = (category.toLowerCase() == 'general')
        ? 'top'
        : category;
    final lang = language ?? 'ar';

    try {
      final queryParams = <String, dynamic>{
        'language': lang,
        'country': 'eg',
        'apikey': _apiKey,
        'category': apiCategory,
        if (page > 1) 'page': page.toString(),
      };

      final response = await apiClient.get(
        '$_baseUrl/news',
        queryParameters: queryParams,
      );

      final data = response is Map<String, dynamic> ? response : response.data;

      final model = NewsdataResponseModel.fromJson(data);
      return model.results;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse NewsData headlines response: $e',
      );
    }
  }
}
