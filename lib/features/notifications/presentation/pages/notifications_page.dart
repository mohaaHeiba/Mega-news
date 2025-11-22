import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/notifications/presentation/controller/notifications_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({super.key});

  // 💡 تم تعديل الدالة لاستخدام مفاتيح الترجمة (intl)
  String formatInterval(BuildContext context, String interval) {
    final loc = context.s;
    switch (interval) {
      case '2h':
        return loc.interval_2h;
      case '4h':
        return loc.interval_4h;
      case '8h':
        return loc.interval_8h;
      case '12h':
        return loc.interval_12h;
      case '16h':
        return loc.interval_16h;
      case '20h':
        return loc.interval_20h;
      case '24h':
        return loc.interval_24h;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.s;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.scheduled_alerts_title), // 💡 تم التعديل
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.subscriptions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  loc.no_active_alerts, // 💡 تم التعديل
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(loc.subscribe_instruction), // 💡 تم التعديل
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.subscriptions.length,
          itemBuilder: (context, index) {
            final sub = controller.subscriptions[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  child: Icon(Icons.tag, color: Theme.of(context).primaryColor),
                ),
                title: Text(
                  sub['topic'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  // 💡 استخدام الترجمة للدالة
                  "${loc.repeats_every}: ${formatInterval(context, sub['interval'])}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // تأكيد الحذف
                    Get.defaultDialog(
                      title: loc.delete_alert_title, // 💡 تم التعديل
                      middleText: loc.delete_alert_confirm(
                        sub['topic'],
                      ), // 💡 استخدام دالة لتمرير المتغير
                      textConfirm: loc.yes, // 💡 تم التعديل
                      textCancel: loc.no, // 💡 تم التعديل
                      onConfirm: () {
                        controller.removeSubscription(sub['id'], sub['topic']);
                        Get.back();
                        Get.snackbar(
                          loc.done, // 💡 تم التعديل
                          loc.subscription_cancelled(
                            sub['topic'],
                          ), // 💡 استخدام دالة لتمرير المتغير
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
