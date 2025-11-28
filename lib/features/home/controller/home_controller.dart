import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mega_news/features/settings/controller/theme_controller.dart';

class HomeController extends GetxController {
  final INewsRepository newsRepository;
  final _storage = GetStorage();
  final String _cacheKey = 'cached_news_list';
  final ScrollController scrollController = ScrollController();

  HomeController({required this.newsRepository});

  // ================= Variables =================
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final selectedCategory = 'general'.obs;
  final articles = <Article>[].obs;
  final isOfflineMode = false.obs;

  int _currentPage = 1;
  String currentLanguage = 'en';

  List<Map<String, String>> get categories => [
    {'label': Get.context?.s.category_general ?? 'General', 'value': 'general'},
    {'label': Get.context?.s.category_sports ?? 'Sports', 'value': 'sports'},
    {
      'label': Get.context?.s.category_technology ?? 'Technology',
      'value': 'technology',
    },
    {
      'label': Get.context?.s.category_business ?? 'Business',
      'value': 'business',
    },
    {'label': Get.context?.s.category_health ?? 'Health', 'value': 'health'},
    {'label': Get.context?.s.category_science ?? 'Science', 'value': 'science'},
    {
      'label': Get.context?.s.category_entertainment ?? 'Entertainment',
      'value': 'entertainment',
    },
  ];

  @override
  void onInit() {
    super.onInit();

    // Debug Print 1
    print("🚀 HomeController Started");

    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    currentLanguage = Get.locale?.languageCode ?? 'en';

    if (Get.isRegistered<ThemeController>()) {
      final themeController = Get.find<ThemeController>();
      ever(themeController.language, (lang) => onLanguageChanged());
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });

    fetchNews();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

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

  // ================= Fetch News =================
  Future<void> fetchNews() async {
    print("🔄 fetchNews Called");
    try {
      isLoading(true);
      isOfflineMode(false);
      _currentPage = 1;

      if (Get.isRegistered<ThemeController>()) {
        currentLanguage = Get.find<ThemeController>().language.value;
      }

      print("📡 Calling API...");
      final fetched = await newsRepository.getTopHeadlines(
        category: selectedCategory.value,
        language: currentLanguage,
        page: _currentPage,
      );

      // ========================================================
      // 🔧 التعديل هنا: التعامل مع القائمة الفاضية بذكاء
      // ========================================================

      if (fetched.isNotEmpty) {
        // الحالة 1: النت شغال وجاب داتا
        print("✅ API Success: Got ${fetched.length} articles");
        articles.value = fetched;
        hasMorePages(fetched.length >= 20);

        // نحفظ الجديد
        _saveArticlesLocally(fetched);
      } else {
        // الحالة 2: الـ API رجعت صفر (غالباً النت فاصل بس الـ Repo مرماش Error)
        print(
          "⚠️ API returned 0 items. Assuming Offline/Error -> Checking Cache...",
        );

        // نحاول نجيب من الكاش
        _loadCachedArticles();

        // لو الكاش كمان فاضي، خلاص كدة مفيش حل غير اننا نعرض فاضي
        if (articles.isEmpty) {
          print("☹️ Cache is also empty.");
          hasMorePages(false);
        } else {
          // لو جبنا من الكاش، نظهر رسالة لليوزر
          Get.snackbar(
            'Alert',
            "No Internet Connection. Showing cached news.",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      // الحالة 3: حصل Crash حقيقي (SocketException مثلاً)
      print("❌ API Failed with Exception: $e");
      print("📂 Switching to Offline Cache...");

      _loadCachedArticles();

      Get.snackbar(
        'Alert',
        "No Internet Connection. Showing cached news.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  // ================= Save Local =================
  void _saveArticlesLocally(List<Article> newArticles) {
    try {
      final limitedList = newArticles.take(12).toList();
      final jsonList = limitedList.map((article) => article.toJson()).toList();
      _storage.write(_cacheKey, jsonList);
      print("💾 Saved ${jsonList.length} articles to Cache.");
    } catch (e) {
      print("🔴 Error Saving Cache: $e");
    }
  }

  // ================= Load Local (with Fix) =================
  void _loadCachedArticles() {
    try {
      final rawData = _storage.read(_cacheKey);
      print("📦 Raw Cache Data: $rawData");

      if (rawData != null && rawData is List) {
        final List<Article> cachedArticles = [];

        for (var item in rawData) {
          try {
            // هنا التصليح: بنعمل خريطة جديدة ونضمن ان القيم مش Null
            // عشان الموديل بتاعك ميزعلش
            final Map<String, dynamic> safeMap = Map<String, dynamic>.from(
              item,
            );

            // التأكد من القيم الإجبارية (Required Fields)
            if (safeMap['id'] == null)
              safeMap['id'] = DateTime.now().millisecondsSinceEpoch.toString();
            if (safeMap['title'] == null) safeMap['title'] = "No Title";
            if (safeMap['sourceName'] == null)
              safeMap['sourceName'] = "Cached Source";
            if (safeMap['articleUrl'] == null) safeMap['articleUrl'] = "";
            if (safeMap['publishedAt'] == null)
              safeMap['publishedAt'] = DateTime.now().toIso8601String();

            // دلوقتي نبصيها للموديل وهي آمنة
            cachedArticles.add(Article.fromJson(safeMap));
          } catch (e) {
            print("⚠️ Skipped bad article: $e");
            // لو فيه خبر واحد بايظ، نفوته ونكمل الباقي بدل ما نوقف كله
          }
        }

        print(
          "✅ Successfully parsed ${cachedArticles.length} articles from Cache",
        );

        if (cachedArticles.isNotEmpty) {
          articles.value = cachedArticles;
          isOfflineMode(true);
          hasMorePages(false);
          articles.refresh(); // مهمة جدا لتحديث الواجهة
        } else {
          print("⚠️ Cache parsed list is empty");
        }
      } else {
        print("⛔ No Valid Data in Storage");
      }
    } catch (e) {
      print("🔴 Critical Error Loading Cache: $e");
    }
  }

  // ... LoadMore Logic ...
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMorePages.value || isOfflineMode.value)
      return;
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

  // ... Change Category ...
  void changeCategory(String newCategory) {
    selectedCategory(newCategory);
    _currentPage = 1;
    hasMorePages(true);
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
    fetchNews();
  }

  String getTimeAgo(DateTime dateTime) {
    final String currentAppLang = Get.locale?.languageCode ?? 'en';
    return timeago.format(dateTime, locale: currentAppLang);
  }
}
