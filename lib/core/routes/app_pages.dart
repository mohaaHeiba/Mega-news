import 'package:get/get.dart';
import 'package:mega_news/core/bindings/auth_binding.dart';
import 'package:mega_news/core/bindings/welcome_binding.dart';
import 'package:mega_news/features/auth/presentations/pages/auth_page.dart';
import 'package:mega_news/features/welcome/pages/welcome_page.dart';

class AppPages {
  static String welcomePage = '/welcomePage';
  static String authPage = '/authPage';

  static final List<GetPage> routes = [
    GetPage(
      name: welcomePage,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
      // transition: Transition
    ),
    GetPage(
      name: authPage,
      page: () => AuthPage(),
      binding: AuthBinding(),
      // transition: Transition
    ),
  ];
}
