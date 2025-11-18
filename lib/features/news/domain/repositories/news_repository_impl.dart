import 'package:mega_news/features/news/data/datasources/currentsnewsapi_remote_datasources.dart';
import 'package:mega_news/features/news/data/datasources/gnews_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/mappers/article_mapper.dart';
import 'package:mega_news/features/news/data/datasources/newsapi_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/newsdata_remote_datasource.dart';
import 'package:mega_news/features/news/data/model/currentsnewsapi_remote_model.dart';
import 'package:mega_news/features/news/data/model/gnews_response_model.dart';
import 'package:mega_news/features/news/data/model/newsapi_response_model.dart';
import 'package:mega_news/features/news/data/model/newsdata_response_model.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';

class NewsRepositoryImpl implements INewsRepository {
  final GNewsRemoteDataSourceImpl gNewsSource;
  final NewsApiRemoteDataSourceImpl newsApiSource;
  final NewsDataRemoteDataSourceImpl newsDataSource;
  final CurrentsRemoteDataSourceImpl currentsSource;
  final ArticleMapper mapper;

  NewsRepositoryImpl({
    required this.gNewsSource,
    required this.newsApiSource,
    required this.newsDataSource,
    required this.currentsSource,
    required this.mapper,
  });

  @override
  Future<List<Article>> getTopHeadlines({
    required String category,
    String? language,
    int page = 1,
  }) async {
    try {
      final results = await Future.wait<List<dynamic>>([
        gNewsSource.getTopHeadlines(
          category: category,
          language: language,
          page: page,
        ),
        newsApiSource.getTopHeadlines(
          category: category,
          language: language,
          page: page,
        ),
        newsDataSource.getTopHeadlines(
          category: category,
          language: language,
          page: page,
        ),
        currentsSource.getTopHeadlines(
          category: category,
          language: language,
          page: page,
        ),
      ]);

      final List<Article> articles = [
        ...(results[0] as List<GNewsArticleModel>).map(mapper.fromGNewsModel),
        ...(results[1] as List<NewsApiArticleModel>).map(
          mapper.fromNewsApiModel,
        ),
        ...(results[2] as List<NewsDataArticleModel>).map(
          mapper.fromNewsDataModel,
        ),
        ...(results[3] as List<News>).map(mapper.fromCurrentsModel),
      ];

      articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return articles;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Article>> searchNews(
    String query, {
    String? language,
    int page = 1,
  }) async {
    try {
      final results = await Future.wait<List<dynamic>>([
        gNewsSource.searchNews(query, language: language, page: page),
        newsApiSource.searchNews(query, language: language, page: page),
        newsDataSource.searchNews(query, language: language, page: page),
        currentsSource.searchNews(query, language: language, page: page),
      ]);

      final List<Article> articles = [
        ...(results[0] as List<GNewsArticleModel>).map(mapper.fromGNewsModel),
        ...(results[1] as List<NewsApiArticleModel>).map(
          mapper.fromNewsApiModel,
        ),
        ...(results[2] as List<NewsDataArticleModel>).map(
          mapper.fromNewsDataModel,
        ),
        ...(results[3] as List<News>).map(mapper.fromCurrentsModel),
      ];

      articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return articles;
    } catch (e) {
      rethrow;
    }
  }
}
