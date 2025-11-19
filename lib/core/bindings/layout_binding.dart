import 'package:dio/dio.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/layouts/layout_controller.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/features/gemini/data/datasources/gemini_remote_datasource.dart';
import 'package:mega_news/features/gemini/data/repositories/gemini_repository_impl.dart';
import 'package:mega_news/features/gemini/domain/usecases/get_ai_summary_usecase.dart';
import 'package:mega_news/features/home/controller/home_controller.dart';
import 'package:mega_news/features/news/data/datasources/currents_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/gnews_remote_datasource.dart';
import 'package:mega_news/features/news/data/mappers/article_mapper.dart';
import 'package:mega_news/features/news/data/datasources/newsapi_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/newsdata_remote_datasource.dart';
import 'package:mega_news/features/news/domain/repositories/news_repository_impl.dart';
import 'package:mega_news/features/search/presentations/controller/search_controller.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LayoutController>(LayoutController());
    Get.put(MenuViewController());

    // --- 1. Setup Network & News Repository ---
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

    // --- 2. Setup Gemini Dependencies  ---
    final geminiDataSource = GeminiRemoteDataSourceImpl(Gemini.instance);
    final geminiRepository = GeminiRepositoryImpl(geminiDataSource);
    final getAiSummaryUseCase = GetAiSummaryUseCase(geminiRepository);

    // --- 3. Inject Controllers ---
    Get.put<HomeController>(
      HomeController(newsRepository: newsRepository),
      permanent: true,
    );

    Get.lazyPut<SearchController>(
      () => SearchController(
        newsRepository: newsRepository,
        getAiSummaryUseCase: getAiSummaryUseCase,
      ),
      fenix: true,
    );
  }
}
