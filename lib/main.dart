import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/app.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load .env
  await dotenv.load(fileName: ".env");

  // init gemini
  Gemini.init(apiKey: dotenv.env['GEMINI_API']!);

  // init supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_APIKEY']!,
  );

  // init getStorage(json)
  await GetStorage.init();

  // for language and theme
  Get.putAsync(() async => MenuViewController());

  runApp(const MyApp());
}
