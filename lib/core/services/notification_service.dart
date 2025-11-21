import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
// تأكد من مسار الـ routes
// import 'package:mega_news/core/routes/app_pages.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;

        if (payload != null && payload.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(payload);
            final article = Article(
              id: data['id'] ?? '',
              sourceName: data['sourceName'] ?? 'Unknown',
              author: data['author'] ?? 'Gemini',
              title: data['title'] ?? 'No Title',
              description: data['description'] ?? '',
              articleUrl: data['articleUrl'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              publishedAt:
                  DateTime.tryParse(data['publishedAt'] ?? '') ??
                  DateTime.now(),
              content: data['content'] ?? '',
            );
            Get.toNamed(AppPages.articleDetailPage, arguments: article);
          } catch (e) {
            print("❌ Error parsing notification payload: $e");
          }
        } else {
          print("⚠️ Notification payload is null or empty");
        }
      },
    );
  }

  // دالة العرض (كما هي)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'news_channel_id',
          'Smart Summaries',
          channelDescription: 'AI Generated News Summaries',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
