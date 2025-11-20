import 'package:mega_news/features/favorites/data/repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call(String userId, String articleId) async {
    return await repository.removeFavorite(userId, articleId);
  }
}
