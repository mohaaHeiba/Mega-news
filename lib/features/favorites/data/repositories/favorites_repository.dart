import 'package:mega_news/features/news/domain/entities/article.dart';

abstract class FavoritesRepository {
  Future<List<Article>> getFavorites(String userId);
  Future<void> addFavorite(String userId, Article article);
  Future<void> removeFavorite(String userId, String articleId);
  // New method added
  Future<void> clearAllFavorites(String userId);
}
