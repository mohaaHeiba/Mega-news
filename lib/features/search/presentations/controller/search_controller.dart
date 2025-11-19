import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/gemini/domain/usecases/get_ai_summary_usecase.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:speech_to_text/speech_to_text.dart';

class SearchController extends GetxController {
  final INewsRepository newsRepository;
  final GetAiSummaryUseCase getAiSummaryUseCase;

  SearchController({
    required this.newsRepository,
    required this.getAiSummaryUseCase,
  });

  // ====================================================
  // Reactive State Variables
  // ====================================================
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final articles = <Article>[].obs;
  final isLiked = false.obs;

  // AI & Voice Status
  final isSummarizing = false.obs;
  final isListening = false.obs;

  // Search Control
  final searchTextController = TextEditingController();
  final searchQuery = ''.obs;
  Timer? _debounce;

  int _currentPage = 1;
  String currentLanguage = 'en';

  // Voice Helper
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  // ====================================================
  // Lifecycle Methods
  // ====================================================
  @override
  void onInit() {
    super.onInit();
    searchTextController.addListener(_onSearchChanged);
    _initSpeech();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    _debounce?.cancel();
    _speechToText.stop();
    super.onClose();
  }

  // ====================================================
  // Search Logic
  // ====================================================
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      final query = searchTextController.text.trim();

      if (query != searchQuery.value) {
        searchQuery.value = query;
        if (query.isNotEmpty) {
          _fetchSearchResults();
        } else {
          clearSearch();
        }
      }
    });
  }

  Future<void> _fetchSearchResults() async {
    try {
      isLoading(true);
      _currentPage = 1;
      articles.clear();

      final fetched = await newsRepository.searchNews(
        searchQuery.value,
        language: currentLanguage,
        page: _currentPage,
      );

      articles.value = fetched;
      hasMorePages(fetched.length >= 20);
    } catch (e) {
      // 🛠️ Added Catch Block: Prevents crash if API fails
      print("Search Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMorePages.value || searchQuery.value.isEmpty)
      return;

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
      print('Error loading more search: $e');
      _currentPage--;
    } finally {
      isLoadingMore(false);
    }
  }

  // ====================================================
  // AI Summary Logic (UPDATED)
  // ====================================================

  Future<void> summarizeSearchResults() async {
    if (articles.isEmpty) {
      Get.snackbar('Info', 'Search for articles first');
      return;
    }

    isSummarizing(true);

    try {
      // 1. Extract Images (UI Logic)
      List<String> images = articles
          .map((e) => e.imageUrl)
          .where((url) => url != null && url.isNotEmpty)
          .take(4)
          .cast<String>()
          .toList();

      // 2. Call the UseCase (Business Logic)
      final summary = await getAiSummaryUseCase(
        topic: searchQuery.value,
        articles: articles,
      );

      // 3. Navigate
      Get.toNamed(
        AppPages.articleDetailPage,
        arguments: {
          'topic': searchQuery.value,
          'summary': summary,
          'images': images,
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate summary: $e');
    } finally {
      isSummarizing(false);
    }
  }

  // ====================================================
  // Voice Search Logic
  // ====================================================
  void _initSpeech() {
    _speechToText.initialize().then((val) => _speechEnabled = val);
    _speechToText.statusListener = (status) {
      if (status == 'notListening' || status == 'done') {
        isListening(false);
      }
    };
  }

  void startListening() {
    if (!_speechEnabled) return;
    textController.clear();
    clearSearch();
    isListening(true);
    _speechToText.listen(
      onResult: (result) {
        textController.text = result.recognizedWords;
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      },
    );
  }

  void stopListening() {
    _speechToText.stop();
    isListening(false);
  }

  // ====================================================
  // Helpers
  // ====================================================
  String getTimeAgo(DateTime dateTime) {
    return timeago.format(dateTime, locale: 'ar');
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    articles.clear();
    isLoading(false);
    hasMorePages(false);
  }

  TextEditingController get textController => searchTextController;
}
