import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/notifications/presentation/controller/notifications_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({super.key});

  String formatInterval(String interval) {
    switch (interval) {
      case '2h':
        return "كل ساعتين";
      case '4h':
        return "كل 4 ساعات";
      case '8h':
        return "كل 8 ساعات";
      case '12h':
        return "كل 12 ساعة";
      case '16h':
        return "كل 16 ساعة";
      case '20h':
        return "كل 20 ساعة";
      case '24h':
        return "يومياً";
      default:
        return "غير معروف";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التنبيهات المجدولة"),
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
                  "لا توجد تنبيهات نشطة",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                const Text("ابحث عن موضوع واضغط على الجرس للاشتراك"),
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
                subtitle: Text("يتكرر: ${formatInterval(sub['interval'])}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // تأكيد الحذف
                    Get.defaultDialog(
                      title: "حذف التنبيه",
                      middleText: "هل تريد إيقاف متابعة ${sub['topic']}؟",
                      textConfirm: "نعم",
                      textCancel: "لا",
                      onConfirm: () {
                        controller.removeSubscription(sub['id'], sub['topic']);
                        Get.back();
                        Get.snackbar("تم", "تم إلغاء متابعة ${sub['topic']}");
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
