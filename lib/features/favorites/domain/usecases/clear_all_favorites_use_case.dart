import 'package:mega_news/features/favorites/data/repositories/favorites_repository.dart';

class ClearAllFavoritesUseCase {
  final FavoritesRepository repository;

  ClearAllFavoritesUseCase(this.repository);

  Future<void> call(String userId) async {
    return await repository.clearAllFavorites(userId);
  }
}
