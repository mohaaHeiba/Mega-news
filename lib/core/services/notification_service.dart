import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  // 💡 دالة جديدة: لتحميل الصورة وتخزينها مؤقتاً
  static Future<String?> _downloadAndSaveImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final fileName =
            'notification_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      print('Error downloading image for notification: $e');
    }
    return null;
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required String imageUrl,
  }) async {
    NotificationDetails notificationDetails;

    // 1. الحالة الافتراضية: بدون صورة كبيرة
    const defaultAndroidDetails = AndroidNotificationDetails(
      'news_channel_id',
      'Smart Summaries',
      channelDescription: 'AI Generated News Summaries',
      importance: Importance.max,
      priority: Priority.high,
    );

    // 2. محاولة تحميل الصورة إذا كان الرابط موجودًا
    if (imageUrl.isNotEmpty) {
      final String? bigPicturePath = await _downloadAndSaveImage(imageUrl);

      if (bigPicturePath != null) {
        // 3. إعداد نمط الصورة الكبيرة (Big Picture Style)
        final bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: title,
          summaryText: body,
        );

        // 4. تهيئة تفاصيل الإشعار بنمط الصورة الكبيرة
        final pictureAndroidDetails = AndroidNotificationDetails(
          'news_channel_id',
          'Smart Summaries',
          channelDescription: 'AI Generated News Summaries',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyle,
        );

        notificationDetails = NotificationDetails(
          android: pictureAndroidDetails,
        );
      } else {
        notificationDetails = const NotificationDetails(
          android: defaultAndroidDetails,
        );
      }
    } else {
      notificationDetails = const NotificationDetails(
        android: defaultAndroidDetails,
      );
    }

    // 5. عرض الإشعار
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
