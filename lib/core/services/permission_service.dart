import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestMicrophone() async {
    if (!await Permission.microphone.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> requestNotification() async {
    if (!await Permission.notification.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> requestAll() async {
    await requestMicrophone();
    await requestNotification();
  }

  Future<bool> get isMicrophoneGranted async =>
      await Permission.microphone.isGranted;

  Future<bool> get isNotificationGranted async =>
      await Permission.notification.isGranted;
}
