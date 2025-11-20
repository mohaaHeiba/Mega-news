import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mega_news/core/errors/supabase_exception.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<Article>> getFavorites(String userId);
  Future<void> addFavorite(String userId, Article article);
  Future<void> removeFavorite(String userId, String articleId);
  Future<void> clearAllFavorites(String userId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final SupabaseClient supabase;

  FavoritesRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<Article>> getFavorites(String userId) async {
    try {
      final response = await supabase
          .from('favorites')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<Article>((item) {
        final articleData = item['article_data'] as Map<String, dynamic>;
        return Article(
          id: articleData['id'] as String,
          title: articleData['title'] as String,
          description: articleData['description'] as String?,
          imageUrl: articleData['imageUrl'] as String?,
          sourceName: articleData['sourceName'] as String,
          articleUrl: articleData['articleUrl'] as String,
          publishedAt: DateTime.parse(articleData['publishedAt'] as String),
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to fetch favorites: ${e.message}',
        e.code,
      );
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> addFavorite(String userId, Article article) async {
    try {
      await supabase.from('favorites').insert({
        'user_id': userId,
        'article_id': article.id,
        'article_data': {
          'id': article.id,
          'title': article.title,
          'description': article.description,
          'imageUrl': article.imageUrl,
          'sourceName': article.sourceName,
          'articleUrl': article.articleUrl,
          'publishedAt': article.publishedAt.toIso8601String(),
        },
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') return; // Already exists
      throw SupabaseDatabaseException(
        'Failed to add favorite: ${e.message}',
        e.code,
      );
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(String userId, String articleId) async {
    try {
      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('article_id', articleId);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to remove favorite: ${e.message}',
        e.code,
      );
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAllFavorites(String userId) async {
    try {
      await supabase.from('favorites').delete().eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw SupabaseDatabaseException(
        'Failed to clear favorites: ${e.message}',
        e.code,
      );
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }
}
