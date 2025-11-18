import 'package:get/get.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';

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
  String _currentLanguage = 'en';

  // ====================================================
  // Categories
  // ====================================================
  final categories = [
    {'label': 'General', 'value': 'general'},
    {'label': 'Sports', 'value': 'sports'},
    {'label': 'Technology', 'value': 'technology'},
    {'label': 'Business', 'value': 'business'},
    {'label': 'Health', 'value': 'health'},
    {'label': 'Science', 'value': 'science'},
    {'label': 'Entertainment', 'value': 'entertainment'},
  ];

  // ====================================================
  // On Init
  // ====================================================
  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  // ====================================================
  // Fetch first page of news
  // ====================================================
  Future<void> fetchNews() async {
    try {
      isLoading(true);
      _currentPage = 1;
      final fetched = await newsRepository.getTopHeadlines(
        category: selectedCategory.value,
        language: _currentLanguage,
        page: _currentPage,
      );

      // Debug: Print all fetched articles
      print('--- FETCH PAGE $_currentPage ---');
      for (var a in fetched) {
        print('${a.title} | ${a.sourceName}');
      }
      print('--- END OF PAGE ---');

      articles.value = fetched;
      hasMorePages(fetched.length >= 20);
    } catch (e) {
      print('Error fetching news: $e');
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
        language: _currentLanguage,
        page: _currentPage,
      );
      if (fetched.isEmpty) {
        hasMorePages(false);
      } else {
        articles.addAll(fetched);
        if (fetched.length < 20) hasMorePages(false);

        // ======= PRINT ALL DATA AFTER LOAD MORE =======
        print('--- LOAD MORE PAGE $_currentPage ---');
        for (var a in articles) {
          print('${a.title} | ${a.sourceName}');
        }
        print('--- END OF LOAD MORE ---');
      }
    } catch (e) {
      print('Error loading more: $e');
      _currentPage--; // revert page
    } finally {
      isLoadingMore(false);
    }
  }

  // ====================================================
  // Load more for pagination
  // ====================================================

  // ====================================================
  // Change category
  // ====================================================
  void changeCategory(String newCategory) {
    selectedCategory(newCategory);
    _currentPage = 1;
    hasMorePages(true);
    fetchNews();
  }
}
