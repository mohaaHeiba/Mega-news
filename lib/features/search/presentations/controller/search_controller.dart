import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/custom/snackbars/custom_snackbar.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/gemini/domain/usecases/get_ai_summary_usecase.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/features/news/domain/repositories/i_news_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:mega_news/generated/l10n.dart';

class SearchController extends GetxController {
  final INewsRepository newsRepository;
  final GetAiSummaryUseCase getAiSummaryUseCase;

  SearchController({
    required this.newsRepository,
    required this.getAiSummaryUseCase,
  });

  // 2. Getter for Translation
  S get s => S.of(Get.context!);

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final articles = <Article>[].obs;
  final isSummarizing = false.obs;
  final isListening = false.obs;

  final searchTextController = TextEditingController();
  final searchQuery = ''.obs;
  Timer? _debounce;

  String? _cachedSummary;
  int _currentPage = 1;
  String currentLanguage = 'en';

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void onInit() {
    super.onInit();
    currentLanguage = Get.locale?.languageCode ?? 'en';
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
  //
  // ====================================================
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
      _cachedSummary = null;

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

  Future<void> summarizeSearchResults() async {
    if (articles.isEmpty) {
      // 3. Use customSnackbar (Info/Warning)
      customSnackbar(
        title: s.info_title,
        message: s.search_articles_first_msg,
        color: AppColors.warning,
      );
      return;
    }
    List<String> images = articles
        .map((e) => e.imageUrl)
        .where((url) => url != null && url.isNotEmpty)
        .take(4)
        .cast<String>()
        .toList();

    if (_cachedSummary != null) {
      Get.toNamed(
        AppPages.articleDetailPage,
        arguments: {
          'topic': searchQuery.value,
          'summary': _cachedSummary,
          'images': images,
        },
      );
      return;
    }

    isSummarizing(true);
    try {
      final summary = await getAiSummaryUseCase(
        topic: searchQuery.value,
        articles: articles,
      );
      _cachedSummary = summary;
      Get.toNamed(
        AppPages.articleDetailPage,
        arguments: {
          'topic': searchQuery.value,
          'summary': summary,
          'images': images,
        },
      );
    } catch (e) {
      // 4. Use customSnackbar (Error)
      customSnackbar(
        title: s.error_title,
        message: '${s.ai_summary_generation_error} $e',
        color: AppColors.error,
      );
    } finally {
      isSummarizing(false);
    }
  }

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
    currentLanguage = Get.locale?.languageCode ?? 'en';

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

  String getTimeAgo(DateTime dateTime) =>
      timeago.format(dateTime, locale: Get.locale?.languageCode ?? 'en');

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    articles.clear();
    _cachedSummary = null;
    isLoading(false);
    hasMorePages(false);
  }

  TextEditingController get textController => searchTextController;
}
