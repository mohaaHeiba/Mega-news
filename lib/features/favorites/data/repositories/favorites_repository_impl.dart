import 'package:mega_news/core/services/network_service.dart';
import 'package:mega_news/features/favorites/data/dataSource/favorites_local_data_source.dart';
import 'package:mega_news/features/favorites/data/dataSource/favorites_remote_datasource.dart';
import 'package:mega_news/features/favorites/data/repositories/favorites_repository.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Article>> getFavorites(String userId) async {
    if (userId == 'guest') {
      return await localDataSource.getCachedFavorites();
    }

    if (await NetworkService.isConnected) {
      await syncPendingOperations(userId);
    }

    if (await NetworkService.isConnected) {
      try {
        final remoteFavorites = await remoteDataSource.getFavorites(userId);
        await localDataSource.cacheFavorites(remoteFavorites);
        return remoteFavorites;
      } catch (e) {
        return await localDataSource.getCachedFavorites();
      }
    } else {
      return await localDataSource.getCachedFavorites();
    }
  }

  @override
  Future<void> addFavorite(String userId, Article article) async {
    await localDataSource.addFavoriteLocally(article);

    if (userId == 'guest') return;

    if (await NetworkService.isConnected) {
      await remoteDataSource.addFavorite(userId, article);
    }
  }

  @override
  Future<void> removeFavorite(String userId, String articleId) async {
    await localDataSource.removeFavoriteLocally(articleId);

    if (userId == 'guest') return;

    if (await NetworkService.isConnected) {
      await remoteDataSource.removeFavorite(userId, articleId);
    }
  }

  @override
  Future<void> clearAllFavorites(String userId) async {
    await localDataSource.clearFavoritesCache();

    if (userId == 'guest') return;

    if (await NetworkService.isConnected) {
      try {
        await remoteDataSource.clearAllFavorites(userId);
        await localDataSource.setClearAllPending(false);
      } catch (e) {
        await localDataSource.setClearAllPending(true);
        rethrow;
      }
    } else {
      await localDataSource.setClearAllPending(true);
    }
  }

  @override
  Future<void> syncPendingOperations(String userId) async {
    if (userId == 'guest') return;

    if (localDataSource.isClearAllPending) {
      if (await NetworkService.isConnected) {
        try {
          print("Syncing: Clearing remote favorites...");
          await remoteDataSource.clearAllFavorites(userId);
          await localDataSource.setClearAllPending(false);
          print("Syncing: Success");
        } catch (e) {
          print("Syncing failed: $e");
        }
      }
    }
  }
}
