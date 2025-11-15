import 'package:get/get.dart';
import 'package:mega_news/features/welcome/presentations/pages/welcome_page.dart';

class AppPages {
  static String welcomePage = '/welcomePage';

  static final List<GetPage> routes = [
    GetPage(name: welcomePage, page: () => WelcomePage()),
  ];
}
