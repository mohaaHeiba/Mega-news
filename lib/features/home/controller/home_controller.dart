import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mega_news/features/settings/presentations/controller/theme_controller.dart';

class HomeController extends GetxController {
  final INewsRepository newsRepository;

  HomeController({required this.newsRepository});

  // ====================================================
  // Reactive state
  // ====================================================
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final selectedCategory = 'general'.obs;
  final articles = <Article>[].obs;

  int _currentPage = 1;
  String currentLanguage = 'en';

  // ====================================================
  // Categories
  // ====================================================
  List<Map<String, String>> get categories => [
    {'label': Get.context!.s.category_general, 'value': 'general'},
    {'label': Get.context!.s.category_sports, 'value': 'sports'},
    {'label': Get.context!.s.category_technology, 'value': 'technology'},
    {'label': Get.context!.s.category_business, 'value': 'business'},
    {'label': Get.context!.s.category_health, 'value': 'health'},
    {'label': Get.context!.s.category_science, 'value': 'science'},
    {'label': Get.context!.s.category_entertainment, 'value': 'entertainment'},
  ];

  // ====================================================
  // On Init
  // ====================================================
  @override
  void onInit() {
    super.onInit();

    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());

    currentLanguage = Get.locale?.languageCode ?? 'en';

    if (Get.isRegistered<ThemeController>()) {
      final themeController = Get.find<ThemeController>();

      ever(themeController.language, (lang) {
        onLanguageChanged();
      });
    }

    fetchNews();
  }

  // ====================================================
  // Call MenuView (Automatic Refresh Logic)
  // ====================================================
  void onLanguageChanged() {
    if (Get.isRegistered<ThemeController>()) {
      currentLanguage = Get.find<ThemeController>().language.value;
    } else {
      currentLanguage = Get.locale?.languageCode ?? 'en';
    }

    _currentPage = 1;
    hasMorePages(true);
    articles.clear();

    fetchNews();
  }

  // ====================================================
  // Fetch first page of news
  // ====================================================
  Future<void> fetchNews() async {
    try {
      isLoading(true);
      _currentPage = 1;

      if (Get.isRegistered<ThemeController>()) {
        currentLanguage = Get.find<ThemeController>().language.value;
      }

      final fetched = await newsRepository.getTopHeadlines(
        category: selectedCategory.value,
        language: currentLanguage,
        page: _currentPage,
      );

      articles.value = fetched;
      hasMorePages(fetched.length >= 20);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMorePages.value) return;

    try {
      isLoadingMore(true);
      _currentPage++;
      final fetched = await newsRepository.getTopHeadlines(
        category: selectedCategory.value,
        language: currentLanguage,
        page: _currentPage,
      );
      if (fetched.isEmpty) {
        hasMorePages(false);
      } else {
        articles.addAll(fetched);
        if (fetched.length < 20) hasMorePages(false);
      }
    } catch (e) {
      _currentPage--;
    } finally {
      isLoadingMore(false);
    }
  }

  String getTimeAgo(DateTime dateTime) {
    final String currentAppLang = Get.locale?.languageCode ?? 'en';
    return timeago.format(dateTime, locale: currentAppLang);
  }

  void changeCategory(String newCategory) {
    selectedCategory(newCategory);
    _currentPage = 1;
    hasMorePages(true);
    fetchNews();
  }
}
