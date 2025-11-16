import 'package:mega_news/features/auth/domain/entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login({required String email, required String password});

  Future<AuthEntity> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthEntity?> getCurrentUser();

  Future<void> logout();

  Future<AuthEntity> googleSignIn();

  Future<void> deleteAccount(String userId);

  Future<void> resetPassword(String email);

  Future<void> updatePassword(String newPassword);

  bool get isLoggedIn;
}
