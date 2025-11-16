import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:mega_news/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mega_news/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mega_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 1) Register GetStorage instance

    Get.lazyPut<GetStorage>(() => GetStorage());

    // 2) Register Local DataSource
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(Get.find<GetStorage>()),
    );

    // 3) Register Remote DataSource
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());

    // 4) Register Repository (implementation, not abstract)
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<AuthRemoteDataSource>(),
        Get.find<AuthLocalDataSource>(),
      ),
    );

    // 5) Register Controller
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
