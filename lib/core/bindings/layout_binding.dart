import 'package:dio/dio.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/favorites/data/dataSource/favorites_local_data_source.dart';
import 'package:mega_news/features/favorites/data/dataSource/favorites_remote_datasource.dart';
import 'package:mega_news/features/favorites/data/repositories/favorites_repository.dart';
import 'package:mega_news/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:mega_news/features/favorites/domain/usecases/add_favorites_use_case.dart';
import 'package:mega_news/features/favorites/domain/usecases/clear_all_favorites_use_case.dart';
import 'package:mega_news/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:mega_news/features/favorites/domain/usecases/remove_favorites_use_case.dart';
import 'package:mega_news/features/notifications/presentation/controller/notifications_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mega_news/core/layouts/layout_controller.dart';
import 'package:mega_news/core/network/api_cleint.dart';
import 'package:mega_news/features/settings/controller/menu_view_controller.dart';

import 'package:mega_news/features/home/controller/home_controller.dart';
import 'package:mega_news/features/news/data/datasources/currents_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/gnews_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/newsapi_remote_datasource.dart';
import 'package:mega_news/features/news/data/datasources/newsdata_remote_datasource.dart';
import 'package:mega_news/features/news/data/mappers/article_mapper.dart';
import 'package:mega_news/features/news/domain/repositories/news_repository_impl.dart';

import 'package:mega_news/features/briefing/controller/briefing_controller.dart';
import 'package:mega_news/features/gemini/data/datasources/gemini_remote_datasource.dart';
import 'package:mega_news/features/gemini/data/repositories/gemini_repository_impl.dart';
import 'package:mega_news/features/gemini/domain/usecases/get_ai_summary_usecase.dart';

import 'package:mega_news/features/search/controller/search_controller.dart';

import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    // --- Core Controllers ---
    Get.put<LayoutController>(LayoutController());
    Get.put(MenuViewController());

    // ==========================================================
    // 1. Setup Network & News Repository
    // ==========================================================
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

    // ==========================================================
    // 2. Setup Gemini Dependencies
    // ==========================================================
    final geminiDataSource = GeminiRemoteDataSourceImpl(Gemini.instance);
    final geminiRepository = GeminiRepositoryImpl(geminiDataSource);
    final getAiSummaryUseCase = GetAiSummaryUseCase(geminiRepository);

    // ==========================================================
    // 3. Setup Favorites Dependencies
    // ==========================================================

    // Data Sources
    final favoritesRemoteDS = FavoritesRemoteDataSourceImpl(
      supabase: Supabase.instance.client,
    );
    final favoritesLocalDS = FavoritesLocalDataSourceImpl();

    // Repository
    final favoritesRepository = Get.put<FavoritesRepository>(
      FavoritesRepositoryImpl(
        remoteDataSource: favoritesRemoteDS,
        localDataSource: favoritesLocalDS,
      ),
    );

    // Use Cases
    final getFavoritesUseCase = GetFavoritesUseCase(favoritesRepository);
    final addFavoriteUseCase = AddFavoriteUseCase(favoritesRepository);
    final removeFavoriteUseCase = RemoveFavoriteUseCase(favoritesRepository);

    final clearAllFavoritesUseCase = ClearAllFavoritesUseCase(
      favoritesRepository,
    );

    // ==========================================================
    // 4. Inject Controllers
    // ==========================================================

    // Home Controller
    Get.put<HomeController>(
      HomeController(newsRepository: newsRepository),
      permanent: true,
    );

    // Search Controller
    Get.lazyPut<SearchController>(
      () => SearchController(
        newsRepository: newsRepository,
        getAiSummaryUseCase: getAiSummaryUseCase,
      ),
      fenix: true,
    );

    // Briefing Controller
    Get.lazyPut<AiBriefingController>(
      () => AiBriefingController(
        newsRepository: newsRepository,
        getAiSummaryUseCase: getAiSummaryUseCase,
      ),
      fenix: true,
    );

    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );

    // Favorites Controller
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(
        getFavoritesUseCase: getFavoritesUseCase,
        addFavoriteUseCase: addFavoriteUseCase,
        removeFavoriteUseCase: removeFavoriteUseCase,
        clearAllFavoritesUseCase: clearAllFavoritesUseCase,
      ),
    );
  }
}
