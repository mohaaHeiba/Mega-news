import 'package:get/get.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';

class ArticleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => ArticleDetailController());
  }
}
