import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/layouts/layout_controller.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/features/home/controller/home_controller.dart';
import 'package:mega_news/features/news/data/datasources/currents_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/gnews_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/mappers/article_mapper.dart';
import 'package:mega_news/features/news/data/datasources/newsapi_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/newsdata_remote_datasource.dart';
import 'package:mega_news/features/news/domain/repositories/news_repository_impl.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LayoutController>(LayoutController(), permanent: true);

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

    // تمرير الـ repository للـ controller
    Get.put<HomeController>(
      HomeController(newsRepository: newsRepository),
      permanent: true,
    );
  }
}
