import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  // Check connection once
  static Future<bool> get isConnected async =>
      await InternetConnection().hasInternetAccess;

  // Stream to listen to connectivity changes
  // static Stream<bool> get onStatusChange => InternetConnection().onStatusChange
  //     .map((InternetStatus status) => status == InternetStatus.connected);

  // // Retry helper
  // static Future<T?> retry<T>(Future<T> Function() task, {int times = 3}) async {
  //   for (int i = 0; i < times; i++) {
  //     if (await isConnected) {
  //       try {
  //         return await task();
  //       } catch (_) {}
  //     }
  //     await Future.delayed(const Duration(seconds: 2));
  //   }
  //   return null;
  // }

  // nah maybe mabye: timeout
  // static Future<bool> get isConnectedWithTimeout async {
  //   try {
  //     return await InternetConnection().hasInternetAccess.timeout(
  //       const Duration(seconds: 5),
  //       onTimeout: () => false,
  //     );
  //   } catch (_) {
  //     return false;
  //   }
  // }
}
