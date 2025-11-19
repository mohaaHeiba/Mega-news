import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mega_news/core/errors/api_exception.dart';
import 'package:mega_news/features/news/data/mappers/article_mapper.dart';
import 'package:mega_news/features/news/data/model/currentsnewsapi_remote_model.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

abstract class ICurrentsRemoteDataSourceLatestNews {
  Future<List<Article>> getLatestNews({
    String language = 'ar',
    String category = 'general',
  });
}

class CurrentsRemoteDataSourceImpl
    implements ICurrentsRemoteDataSourceLatestNews {
  final Dio dio;
  final ArticleMapper articleMapper;

  final String _apiKey = dotenv.env['CURRENTS_API']!;
  final String _baseUrl = 'https://api.currentsapi.services/v1';
  final String _placeholder =
      'https://via.placeholder.com/500x300?text=No+Image';

  CurrentsRemoteDataSourceImpl({
    required this.dio,
    required this.articleMapper,
  });

  @override
  Future<List<Article>> getLatestNews({
    String language = 'ar',
    String category = 'general',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'language': language,
        'category': category,
        'apiKey': _apiKey,
      };

      print('🔹 CurrentsAPI Query Params: $queryParams');

      final response = await dio.get(
        '$_baseUrl/latest-news',
        queryParameters: queryParams,
      );

      print('✅ CurrentsAPI Raw Response: ${response.data}');

      // Parse the response
      final model = CurrentsNewsApiResponseModel.fromJson(response.data);

      print('🔹 Number of articles received: ${model.news.length}');

      // Handle empty fields and convert to Article entities
      final articles = model.news.map((newsItem) {
        final sourceName = (newsItem.author ?? '').isEmpty
            ? 'Currents'
            : newsItem.author;

        final imageUrl = (newsItem.image ?? '').isEmpty
            ? _placeholder
            : newsItem.image;

        final correctedNews = News(
          id: newsItem.id,
          title: newsItem.title,
          description: newsItem.description,
          url: newsItem.url,
          author: sourceName,
          image: imageUrl,
          language: newsItem.language,
          category: newsItem.category,
          published: newsItem.published,
        );

        return articleMapper.fromCurrentsModel(correctedNews);
      }).toList();

      print('🔹 Parsed Articles Count after mapping: ${articles.length}');

      return articles;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw NetworkException(
        message: 'Failed to fetch Currents latest news: ${e.message}',
      );
    } catch (e) {
      print('❌ Unknown error during parsing: $e');
      return [];
    }
  }
}
