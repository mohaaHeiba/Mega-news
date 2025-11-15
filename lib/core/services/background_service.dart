// import 'package:background_fetch/background_fetch.dart';
// import 'network_service.dart';
// import 'notification_service.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<List<Map<String, dynamic>>> fetchNews(List<String> userCategories) async {
//   if (userCategories.isEmpty) return [];

//   final query = userCategories.join(','); // مثال: "sports,tech"
//   final response = await http.get(Uri.parse('https://api.example.com/news?categories=$query'));

//   if (response.statusCode == 200) {
//     return List<Map<String, dynamic>>.from(jsonDecode(response.body));
//   }
//   return [];
// }
// void backgroundFetchTask(String taskId) async {
//   bool connected = await NetworkService.isConnected;
//   if (!connected) {
//     BackgroundFetch.finish(taskId);
//     return;
//   }

//   // جلب اهتمامات المستخدم
//   final userCategories = await UserPreferencesService.getSelectedCategories();
//   if (userCategories.isEmpty) {
//     BackgroundFetch.finish(taskId);
//     return;
//   }

//   // جلب الأخبار فقط للفئات المختارة
//   final news = await fetchNews(userCategories);
//   for (var item in news) {
//     NotificationService.show(
//       "خبر جديد في ${item['category'] ?? ''}",
//       item['title'] ?? "لديك أخبار جديدة",
//     );
//   }

//   BackgroundFetch.finish(taskId);
// }

// }
