import 'package:get/get.dart';
import 'package:mega_news/core/services/permission_service.dart';
import '../../features/welcome/controllers/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PermissionService());
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}
