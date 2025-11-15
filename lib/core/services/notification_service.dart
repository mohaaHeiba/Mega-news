import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  /// title = عنوان الإشعار
  /// body = نص الإشعار
  /// imageUrl = رابط الصورة أو path محلي
  static Future<void> show(
    String title,
    String body, {
    String? imageUrl,
  }) async {
    AndroidNotificationDetails androidDetails;

    if (imageUrl != null) {
      final bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(imageUrl),
        contentTitle: title,
        summaryText: body,
      );

      androidDetails = AndroidNotificationDetails(
        'news_channel',
        'News Channel',
        channelDescription: 'Channel for news notifications',
        styleInformation: bigPictureStyle,
        importance: Importance.max,
        priority: Priority.high,
      );
    } else {
      androidDetails = AndroidNotificationDetails(
        'news_channel',
        'News Channel',
        channelDescription: 'Channel for news notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
    }

    final platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(0, title, body, platformDetails);
  }
}
