import 'package:get_storage/get_storage.dart';
import 'app_pages.dart';

class AppRoutesHelper {
  static String getInitialRoute() {
    final box = GetStorage();
    final seenWelcome = box.read('seenWelcome') ?? false;
    final isLoggedIn = box.read('loginBefore') ?? false;

    return !seenWelcome
        ? AppPages.welcomePage
        : (!isLoggedIn ? AppPages.authPage : AppPages.layoutPage);
  }
}
