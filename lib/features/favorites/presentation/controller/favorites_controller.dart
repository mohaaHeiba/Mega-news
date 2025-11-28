import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/custom/custom_snackbar.dart';
import 'package:mega_news/features/favorites/domain/usecases/add_favorites_use_case.dart';
import 'package:mega_news/features/favorites/domain/usecases/clear_all_favorites_use_case.dart'; // تأكد من استيراد هذا الملف
import 'package:mega_news/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:mega_news/features/favorites/domain/usecases/remove_favorites_use_case.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesController extends GetxController {
  // Use Cases (Dependencies)
  final GetFavoritesUseCase getFavoritesUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final ClearAllFavoritesUseCase clearAllFavoritesUseCase;

  FavoritesController({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.clearAllFavoritesUseCase, // مطلوب في الـ Constructor
  });

  // State
  var favorites = <Article>[].obs;
  var isLoading = false.obs;

  // Helpers to get User ID safely
  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'guest';

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Load favorites (Repository decides whether to bring from Supabase or Cache)
  Future<void> loadFavorites() async {
    isLoading.value = true;
    try {
      final result = await getFavoritesUseCase(_userId);
      favorites.assignAll(result);
    } catch (e) {
      customSnackbar(
        title: 'Error',
        message: 'Failed to load favorites: ${e.toString()}',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Add Favorite
  Future<void> addFavorite(Article article) async {
    final s = S.current; // Localization

    // Optimistic Update: Add to UI immediately
    favorites.insert(0, article);

    try {
      await addFavoriteUseCase(_userId, article);

      customSnackbar(
        title: s.addedToFavorites,
        message: s.articleSavedToFavorites,
        color: AppColors.success,
      );
    } catch (e) {
      // Rollback if failed
      favorites.remove(article);
      customSnackbar(
        title: 'Error',
        message: 'Failed to add favorites: ${e.toString()}',
        color: AppColors.error,
      );
    }
  }

  Future<void> syncGuestFavoritesToUser() async {
    final realUserId = Supabase.instance.client.auth.currentUser?.id;

    if (realUserId != null && favorites.isNotEmpty) {
      final localArticles = List<Article>.from(favorites);

      final syncTasks = localArticles.map((article) async {
        try {
          await addFavoriteUseCase(realUserId, article);
        } catch (e) {
          print("Failed to sync article ${article.id}: $e");
        }
      });

      await Future.wait(syncTasks);

      await loadFavorites();
    }
  }

  /// Remove Favorite
  Future<void> removeFavorite(Article article) async {
    final s = S.current;

    // Optimistic Update
    final index = favorites.indexOf(article);
    if (index == -1) return;

    favorites.removeAt(index);

    try {
      await removeFavoriteUseCase(_userId, article.id);

      customSnackbar(
        title: s.removed,
        message: s.articleRemovedFromFavoritesShort,
        color: AppColors.success,
      );
    } catch (e) {
      // Rollback
      favorites.insert(index, article);
      customSnackbar(
        title: 'Error',
        message: 'Failed to remove favorites: ${e.toString()}',
        color: AppColors.error,
      );
    }
  }

  /// Clear All Favorites (Function to fix the UI issue and Guest Error)
  Future<void> clearAllFavorites() async {
    // 1. حفظ نسخة احتياطية في حال الفشل الحقيقي
    final previousFavorites = List<Article>.from(favorites);

    // 2. تحديث الواجهة فوراً (Optimistic UI Update)
    favorites.clear();

    try {
      // 3. استدعاء الدالة لحذف البيانات
      await clearAllFavoritesUseCase(_userId);

      Get.snackbar(
        'Success',
        'All favorites cleared successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // 4. معالجة الأخطاء الذكية
      final errorMsg = e.toString().toLowerCase();

      // إذا كان الخطأ بسبب أن الـ ID هو "guest" (ليس UUID صالح)،
      // فهذا يعني أننا نجحنا في الحذف المحلي (لأننا نظفنا القائمة فوق)،
      // وفشلنا فقط في محاولة الاتصال بـ Supabase، وهذا متوقع للضيف.
      if (_userId.contains('guest') &&
          (errorMsg.contains('uuid') || errorMsg.contains('invalid input'))) {
        print("Guest local clear successful, ignored remote error.");
        return; // لا تظهر رسالة خطأ، ولا تقم باسترجاع البيانات
      }

      // 5. إذا كان خطأ حقيقي (مثل انقطاع نت لمستخدم مسجل)، نعيد البيانات
      print("Error clearing favorites: $e");
      favorites.assignAll(previousFavorites);

      customSnackbar(
        title: 'Error',
        message: 'Failed to clear favorites',
        color: AppColors.error,
      );
    }
  }

  /// Check if article is favorite
  bool isFavorite(String articleId) {
    return favorites.any((element) => element.id == articleId);
  }

  /// Toggle logic for the UI button
  void toggleFavorite(Article article) {
    if (isFavorite(article.id)) {
      removeFavorite(article);
    } else {
      addFavorite(article);
    }
  }

  List<Article> get aiSummaries {
    return favorites.where((article) {
      return article.sourceName == "AI Summary" ||
          article.sourceName == "AI Briefing";
    }).toList();
  }

  List<Article> get normalArticles {
    return favorites.where((article) {
      return article.sourceName != "AI Summary" &&
          article.sourceName != "AI Briefing";
    }).toList();
  }
}
