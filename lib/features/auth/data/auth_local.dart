import 'package:get_storage/get_storage.dart';
import 'package:mega_news/features/auth/domain/entity/auth_entity.dart';

class AuthLocalService {
  final GetStorage _storage = GetStorage();

  static const String _authKey = 'auth_data';

  Future<void> saveAuthData(AuthEntity auth) async {
    await _storage.write(_authKey, {
      'id': auth.id,
      'name': auth.name,
      'email': auth.email,
      'createdAt': auth.createdAt,
    });
  }

  AuthEntity? getAuthData() {
    final data = _storage.read(_authKey);
    if (data == null) return null;

    return AuthEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      createdAt: data['createdAt'] as String?,
    );
  }

  Future<void> clearAuthData() async {
    await _storage.remove(_authKey);
  }
}
