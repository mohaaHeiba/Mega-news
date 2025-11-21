import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestMicrophone() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> requestNotification() async {
    var status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> requestAll() async {
    await requestMicrophone();
    await requestNotification();
    // await requestCamera();
  }

  Future<bool> get isMicrophoneGranted async =>
      await Permission.microphone.isGranted;

  Future<bool> get isNotificationGranted async =>
      await Permission.notification.isGranted;

  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
