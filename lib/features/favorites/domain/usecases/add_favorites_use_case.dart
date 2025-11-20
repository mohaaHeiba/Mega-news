import 'package:mega_news/features/favorites/data/repositories/favorites_repository.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(String userId, Article article) async {
    return await repository.addFavorite(userId, article);
  }
}
