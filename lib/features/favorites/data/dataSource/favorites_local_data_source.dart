import 'package:get_storage/get_storage.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

abstract class FavoritesLocalDataSource {
  Future<void> cacheFavorites(List<Article> articles);
  Future<List<Article>> getCachedFavorites();
  Future<void> addFavoriteLocally(Article article);
  Future<void> removeFavoriteLocally(String articleId);
  Future<void> clearFavoritesCache();

  bool get isClearAllPending;
  Future<void> setClearAllPending(bool value);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final GetStorage _box = GetStorage();
  final String _key = 'favorites_cache';
  final String _pendingClearKey = 'pending_clear_all_favorites';

  @override
  Future<void> cacheFavorites(List<Article> articles) async {
    final List<Map<String, dynamic>> jsonList = articles
        .map((article) => article.toJson())
        .toList();

    await _box.write(_key, jsonList);
  }

  @override
  Future<List<Article>> getCachedFavorites() async {
    final List<dynamic>? jsonList = _box.read<List<dynamic>>(_key);

    if (jsonList == null) return [];

    return jsonList
        .map((jsonItem) => Article.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addFavoriteLocally(Article article) async {
    List<Article> currentFavorites = await getCachedFavorites();

    if (!currentFavorites.any((element) => element.id == article.id)) {
      currentFavorites.insert(0, article);
      await cacheFavorites(currentFavorites);
    }
  }

  @override
  Future<void> removeFavoriteLocally(String articleId) async {
    List<Article> currentFavorites = await getCachedFavorites();

    currentFavorites.removeWhere((article) => article.id == articleId);

    await cacheFavorites(currentFavorites);
  }

  @override
  Future<void> clearFavoritesCache() async {
    await _box.remove(_key);
  }

  // Implementation of Sync Flags
  @override
  bool get isClearAllPending => _box.read(_pendingClearKey) ?? false;

  @override
  Future<void> setClearAllPending(bool value) async {
    await _box.write(_pendingClearKey, value);
  }
}
