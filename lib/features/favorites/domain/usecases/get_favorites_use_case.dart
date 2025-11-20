import 'package:mega_news/features/favorites/data/repositories/favorites_repository.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<Article>> call(String userId) async {
    return await repository.getFavorites(userId);
  }
}
