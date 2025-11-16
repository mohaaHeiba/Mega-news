import 'package:get_storage/get_storage.dart';
import 'package:mega_news/features/auth/data/model/auth_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(AuthModel auth);
  AuthModel? getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final GetStorage storage;
  static const _authKey = 'auth_data';

  AuthLocalDataSourceImpl(this.storage);

  @override
  Future<void> saveUser(AuthModel auth) async {
    await storage.write(_authKey, auth.toMap());
  }

  @override
  AuthModel? getUser() {
    final data = storage.read(_authKey);
    if (data == null) return null;
    return AuthModel.fromMap(data);
  }

  @override
  Future<void> clearUser() async {
    await storage.remove(_authKey);
  }
}
