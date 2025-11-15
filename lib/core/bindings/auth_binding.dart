import 'package:get/get.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(PermissionService(), permanent: true);
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
