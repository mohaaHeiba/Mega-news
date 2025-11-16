import 'package:mega_news/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:mega_news/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mega_news/features/auth/domain/entity/auth_entity.dart';
import 'package:mega_news/features/auth/domain/repositories/auth_repository.dart'
    show AuthRepository;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.remote, this.local);

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await remote.signIn(email: email, password: password);
    await local.saveUser(model);
    return model;
  }

  @override
  Future<AuthEntity?> getCurrentUser() async {
    // <-- FIX 2: Return type changed to AuthEntity?
    final model = local.getUser();
    return model; // Model is an AuthModel?, which is compatible with AuthEntity?
  }

  @override // <-- Added @override
  Future<void> logout() async {
    await remote.logout();
    await local.clearUser();
  }

  @override // <-- Added @override
  Future<AuthEntity> signup({
    // <-- FIX 3: Return type changed to AuthEntity
    required String name,
    required String email,
    required String password,
  }) async {
    final model = await remote.signUp(
      name: name,
      email: email,
      password: password,
    );
    await local.saveUser(model);
    return model; // Model is an AuthModel, which is compatible with AuthEntity
  }

  @override // <-- Added @override
  Future<AuthEntity> googleSignIn() async {
    // <-- FIX 4: Return type changed to AuthEntity
    final model = await remote.googleSignIN();
    await local.saveUser(model);
    return model; // Model is an AuthModel, which is compatible with AuthEntity
  }

  @override // <-- Added @override
  Future<void> deleteAccount(String userId) async {
    await remote.deleteAccount(userId);
    await local.clearUser();
  }

  @override // <-- Added @override
  Future<void> resetPassword(String email) async {
    await remote.resetPassword(email);
  }

  @override // <-- Added @override
  Future<void> updatePassword(String newPassword) async {
    await remote.updatePassword(newPassword);
  }

  @override // <-- Added @override
  bool get isLoggedIn => remote.isLoggedIn;
}
