import 'package:get/get.dart';
import 'package:mega_news/core/bindings/welcome_binding.dart';
import 'package:mega_news/features/welcome/pages/welcome_page.dart';

class AppPages {
  static String welcomePage = '/welcomePage';

  static final List<GetPage> routes = [
    GetPage(
      name: welcomePage,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
      // transition: Transition
    ),
  ];
}
