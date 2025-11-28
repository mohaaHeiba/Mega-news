import 'package:get_storage/get_storage.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

abstract class FavoritesLocalDataSource {
  Future<void> cacheFavorites(List<Article> articles);
  Future<List<Article>> getCachedFavorites();
  Future<void> addFavoriteLocally(Article article);
  Future<void> removeFavoriteLocally(String articleId);
  // New method added
  Future<void> clearFavoritesCache();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final GetStorage _box = GetStorage();
  final String _key = 'favorites_cache';

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
}
