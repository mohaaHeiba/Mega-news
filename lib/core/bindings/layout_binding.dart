import 'package:get/get.dart';
import 'package:mega_news/core/layouts/layout_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LayoutController>(LayoutController(), permanent: true);
  }
}
