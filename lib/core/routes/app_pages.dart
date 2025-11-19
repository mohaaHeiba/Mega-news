import 'package:get/get.dart';
import 'package:mega_news/core/bindings/article_detail_binding.dart';
import 'package:mega_news/core/bindings/auth_binding.dart';
import 'package:mega_news/core/bindings/layout_binding.dart';
import 'package:mega_news/core/bindings/welcome_binding.dart';
import 'package:mega_news/core/layouts/main_layout.dart';
import 'package:mega_news/features/article_detail/pages/article_detail_page.dart';
import 'package:mega_news/features/auth/presentations/pages/auth_page.dart';
import 'package:mega_news/features/welcome/pages/welcome_page.dart';

class AppPages {
  static String welcomePage = '/welcomePage';
  static String authPage = '/authPage';
  static String layoutPage = '/layoutPage';
  static String articleDetailPage = '/articleDetailPage';

  static final List<GetPage> routes = [
    GetPage(
      name: welcomePage,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
      // transition: Transition.fadeIn,
      // transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: authPage,
      page: () => AuthPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: layoutPage,
      page: () => MainLayout(),
      binding: LayoutBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: articleDetailPage,
      page: () => ArticleDetailPage(),
      binding: ArticleDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 100),
    ),
  ];
}
