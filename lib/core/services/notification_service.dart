import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. إعدادات الأندرويد (تأكد أن أيقونة التطبيق موجودة في مجلد mipmap)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات التهيئة العامة
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // 2. تهيئة البلاجن
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // الحالة الأولى: التطبيق شغال (Foreground أو Background)
        _handleNotificationTap(response.payload);
      },
    );

    // 3. الحالة الثانية: التطبيق مقفول تماماً (Terminated)
    // بنسأل التطبيق: هل تم فتحه بسبب ضغطة على إشعار؟
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload =
          notificationAppLaunchDetails!.notificationResponse?.payload;

      if (payload != null && payload.isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          _handleNotificationTap(payload);
        });
      }
    }
  }

  // 💡 دالة مركزية لمعالجة الضغط وتوجيه المستخدم
  static void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(payload);

        // تحويل البيانات لـ Article Model
        final article = Article(
          id: data['id'] ?? '',
          sourceName: data['sourceName'] ?? 'Unknown',
          author: data['author'] ?? 'Gemini',
          title: data['title'] ?? 'No Title',
          description: data['description'] ?? '',
          articleUrl: data['articleUrl'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          publishedAt:
              DateTime.tryParse(data['publishedAt'] ?? '') ?? DateTime.now(),
          content: data['content'] ?? '',
        );

        // التوجيه لصفحة التفاصيل
        Get.toNamed(AppPages.articleDetailPage, arguments: article);
      } catch (e) {
        print("❌ Error parsing notification payload: $e");
      }
    } else {
      print("⚠️ Notification payload is null or empty");
    }
  }

  // تحميل الصورة وتخزينها مؤقتاً لعرضها في الإشعار
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

  // دالة عرض الإشعار
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required String imageUrl,
  }) async {
    NotificationDetails notificationDetails;

    // الإعدادات الافتراضية للأندرويد
    const defaultAndroidDetails = AndroidNotificationDetails(
      'news_channel_id', // نفس الـ ID في AndroidManifest لو مستخدمه
      'Smart Summaries',
      channelDescription: 'AI Generated News Summaries',
      importance: Importance.max,
      priority: Priority.high,
    );

    // محاولة تحميل وعرض الصورة الكبيرة
    if (imageUrl.isNotEmpty) {
      final String? bigPicturePath = await _downloadAndSaveImage(imageUrl);

      if (bigPicturePath != null) {
        final bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: title,
          summaryText: body,
        );

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
        // فشل تحميل الصورة، نعرض الإشعار بدونها
        notificationDetails = const NotificationDetails(
          android: defaultAndroidDetails,
        );
      }
    } else {
      // لا توجد صورة أصلاً
      notificationDetails = const NotificationDetails(
        android: defaultAndroidDetails,
      );
    }

    // إظهار الإشعار
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
