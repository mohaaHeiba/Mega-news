import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mega_news/core/errors/api_exception.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/features/news/data/model/currentsnewsapi_remote_model.dart';

abstract class ICurrentsRemoteDataSource {
  Future<List<News>> searchNews(String query, {String? language, int page = 1});

  Future<List<News>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  });
}

class CurrentsRemoteDataSourceImpl implements ICurrentsRemoteDataSource {
  final ApiClient apiClient;

  /// DIRECT API KEY
  final String _apiKey = dotenv.env['CURRENTS_API']!;

  final String _baseUrl = 'https://api.currentsapi.services/v1';

  CurrentsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<News>> searchNews(
    String query, {
    String? language,
    int page = 1,
  }) async {
    try {
      final lang = language ?? 'ar';

      final queryParams = <String, dynamic>{
        'keywords': query,
        'language': lang,
        'apiKey': _apiKey,
        'page_number': page,
      };

      final response = await apiClient.get(
        '$_baseUrl/search',
        queryParameters: queryParams,
      );

      final model = currentsNewsApiResponseModelFromJson(
        response is String ? response : response.toString(),
      );

      return model.news;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse Currents search response: $e',
      );
    }
  }

  @override
  Future<List<News>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  }) async {
    try {
      final lang = language ?? 'ar';

      final queryParams = <String, dynamic>{
        'language': lang,
        'category': category,
        'apiKey': _apiKey,
        'page_number': page,
      };

      final response = await apiClient.get(
        '$_baseUrl/latest-news',
        queryParameters: queryParams,
      );

      final model = currentsNewsApiResponseModelFromJson(
        response is String ? response : response.toString(),
      );

      return model.news;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Failed to parse Currents headlines response: $e',
      );
    }
  }
}
