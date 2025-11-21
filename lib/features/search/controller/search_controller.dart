import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/custom/custom_snackbar.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/generated/l10n.dart';

import 'package:mega_news/features/gemini/domain/usecases/get_ai_summary_usecase.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';

import 'package:mega_news/features/notifications/presentation/controller/notifications_controller.dart';

class SearchController extends GetxController {
  // ==============================================================================
  //  Dependencies
  // ==============================================================================
  final INewsRepository newsRepository;
  final GetAiSummaryUseCase getAiSummaryUseCase;

  SearchController({
    required this.newsRepository,
    required this.getAiSummaryUseCase,
  });

  // Helper for Localization
  S get s => Get.context!.s;

  // ==============================================================================
  //  Storage & State Variables
  // ==============================================================================
  final storage = GetStorage();
  final searchHistory = <String>[].obs;

  // UI State
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final articles = <Article>[].obs;
  final isSummarizing = false.obs;
  final isListening = false.obs;

  // ✅ New Variable for AppBar Animation
  final isAppBarCollapsed = false.obs;

  // Search Controls
  final searchTextController = TextEditingController();
  final searchQuery = ''.obs;
  Timer? _debounce;

  // Caching & Pagination
  String? _cachedSummary;
  int _currentPage = 1;
  String currentLanguage = 'en';

  // Speech to Text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  // ==============================================================================
  // Lifecycle Methods
  // ==============================================================================
  @override
  void onInit() {
    super.onInit();
    currentLanguage = Get.locale?.languageCode ?? 'en';

    // Setup Listeners
    searchTextController.addListener(_onSearchChanged);
    _initSpeech();
    _loadHistory();

    // Handle Notification Launch (Auto-Search & Summarize)
    if (Get.arguments != null && Get.arguments is String) {
      final topicFromNotification = Get.arguments as String;
      debugPrint("📥 Opened from notification: $topicFromNotification");

      searchTextController.text = topicFromNotification;
      searchQuery.value = topicFromNotification;

      _handleNotificationClick(topicFromNotification);
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    _debounce?.cancel();
    _speechToText.stop();
    super.onClose();
  }

  // ==============================================================================
  // Notification Handling Logic
  // ==============================================================================
  void _handleNotificationClick(String topic) async {
    await _fetchSearchResults();
    if (articles.isNotEmpty) {
      debugPrint("🤖 Auto-starting summary for: $topic");
      summarizeSearchResults();
    }
  }

  // ==============================================================================
  // Search History Logic
  // ==============================================================================
  void _loadHistory() {
    List? storedHistory = storage.read<List>('search_history');
    if (storedHistory != null) {
      searchHistory.assignAll(storedHistory.cast<String>());
    }
  }

  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;
    if (searchHistory.contains(query)) {
      searchHistory.remove(query);
    }
    searchHistory.insert(0, query);
    if (searchHistory.length > 10) {
      searchHistory.removeLast();
    }
    storage.write('search_history', searchHistory.toList());
  }

  void removeFromHistory(String query) {
    searchHistory.remove(query);
    storage.write('search_history', searchHistory.toList());
  }

  void clearAllHistory() {
    searchHistory.clear();
    storage.remove('search_history');
  }

  void searchFromHistory(String query) {
    searchTextController.text = query;
    searchTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchTextController.text.length),
    );
  }

  // ==============================================================================
  // Search Logic
  // ==============================================================================
  void onLanguageChanged() {
    currentLanguage = Get.locale?.languageCode ?? 'en';
    clearSearch();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      final query = searchTextController.text.trim();
      if (query != searchQuery.value) {
        searchQuery.value = query;
        if (query.isNotEmpty) {
          _fetchSearchResults();
        } else {
          articles.clear();
        }
      }
    });
  }

  Future<void> _fetchSearchResults() async {
    try {
      isLoading(true);
      _currentPage = 1;
      articles.clear();
      _cachedSummary = null;

      _addToHistory(searchQuery.value);
      currentLanguage = Get.locale?.languageCode ?? 'en';

      final fetched = await newsRepository.searchNews(
        searchQuery.value,
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
    if (isLoadingMore.value ||
        !hasMorePages.value ||
        searchQuery.value.isEmpty) {
      return;
    }
    try {
      isLoadingMore(true);
      _currentPage++;
      final fetched = await newsRepository.searchNews(
        searchQuery.value,
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

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    articles.clear();
    _cachedSummary = null;
    isLoading(false);
    hasMorePages(false);
  }

  // ==============================================================================
  // AI Summary Logic
  // ==============================================================================
  Future<void> summarizeSearchResults() async {
    if (articles.isEmpty) {
      customSnackbar(
        title: s.info_title,
        message: s.search_articles_first_msg,
        color: AppColors.warning,
      );
      return;
    }

    if (_cachedSummary != null) {
      _navigateToSummaryPage(_cachedSummary!);
      return;
    }

    isSummarizing(true);
    try {
      final summary = await getAiSummaryUseCase(
        topic: searchQuery.value,
        articles: articles,
      );
      _cachedSummary = summary;
      _navigateToSummaryPage(summary);
    } catch (e) {
      customSnackbar(
        title: s.error_title,
        message: '${s.ai_summary_generation_error} $e',
        color: AppColors.error,
      );
    } finally {
      isSummarizing(false);
    }
  }

  void _navigateToSummaryPage(String summary) {
    String mainImage = '';
    try {
      mainImage =
          articles
              .firstWhere((e) => e.imageUrl != null && e.imageUrl!.isNotEmpty)
              .imageUrl ??
          '';
    } catch (_) {}

    final String uniqueId =
        'ai_search_${searchQuery.value}_${DateTime.now().millisecondsSinceEpoch}';

    final aiArticle = Article(
      id: uniqueId,
      sourceName: "AI Summary",
      author: "Gemini AI",
      title: searchQuery.value,
      description: summary,
      articleUrl: "https://news.google.com/search?q=${searchQuery.value}",
      imageUrl: mainImage,
      publishedAt: DateTime.now(),
    );

    Get.toNamed(AppPages.articleDetailPage, arguments: aiArticle);
  }

  // ==============================================================================
  // Speech to Text Logic
  // ==============================================================================
  void _initSpeech() {
    _speechToText.initialize().then((val) => _speechEnabled = val);
    _speechToText.statusListener = (status) {
      if (status == 'notListening' || status == 'done') isListening(false);
    };
  }

  void startListening() {
    if (!_speechEnabled) return;
    textController.clear();
    clearSearch();
    isListening(true);
    String localeId = Get.locale?.languageCode == 'ar' ? 'ar_EG' : 'en_US';

    _speechToText.listen(
      onResult: (result) {
        textController.text = result.recognizedWords;
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      },
      localeId: localeId,
    );
  }

  void stopListening() {
    _speechToText.stop();
    isListening(false);
  }

  // ==============================================================================
  // Subscription Logic
  // ==============================================================================
  void subscribeToCurrentTopic(BuildContext context) {
    if (searchQuery.value.trim().isEmpty) {
      customSnackbar(
        title: s.info_title,
        message: "Please enter a topic first",
        color: AppColors.warning,
      );
      return;
    }

    if (!Get.isRegistered<NotificationsController>()) {
      Get.put(NotificationsController());
    }

    Get.find<NotificationsController>().showSubscribeDialog(
      context,
      searchQuery.value,
    );
  }

  // ==============================================================================
  // 🛠 Helpers
  // ==============================================================================
  String getTimeAgo(DateTime dateTime) =>
      timeago.format(dateTime, locale: Get.locale?.languageCode ?? 'en');

  TextEditingController get textController => searchTextController;
}
