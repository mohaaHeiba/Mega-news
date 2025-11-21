import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';

class NotificationsController extends GetxController {
  var subscriptions = <Map<String, dynamic>>[].obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadSubscriptions();
  }

  void loadSubscriptions() {
    List? stored = storage.read<List>('subs');
    if (stored != null) {
      subscriptions.assignAll(stored.cast<Map<String, dynamic>>());
    }
  }

  void addSubscription(String topic, String interval) {
    if (subscriptions.any((element) => element['topic'] == topic)) {
      Get.snackbar("تنبيه", "أنت مشترك بالفعل في هذا الموضوع");
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final uniqueTaskName = "news_task_$topic";

    final newSub = {
      'id': id,
      'topic': topic,
      'interval': interval,
      'taskName': uniqueTaskName,
      'createdAt': DateTime.now().toIso8601String(),
    };

    subscriptions.add(newSub);
    storage.write('subs', subscriptions.toList());

    // تحويل interval لنوع Duration
    final hours = int.tryParse(interval.replaceAll('h', '')) ?? 2;
    final frequency = Duration(hours: hours);

    // تسجيل المهمة الدورية
    Workmanager().registerPeriodicTask(
      uniqueTaskName,
      "fetch_news_task",
      frequency: frequency, // أقل مدة 15 دقيقة على Android
      inputData: {'topic': topic, 'lang': Get.locale?.languageCode ?? 'en'},
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    Get.snackbar("تم الاشتراك", "سيتم تلقي ملخصات $topic كل $hours ساعة");
  }

  void removeSubscription(String id, String topic) {
    final sub = subscriptions.firstWhere(
      (e) => e['id'] == id,
      orElse: () => {},
    );

    if (sub.isNotEmpty) {
      // إلغاء المهمة من الخلفية
      Workmanager().cancelByUniqueName(sub['taskName']);
      print("🛑 Task Cancelled: ${sub['taskName']}");
    }

    subscriptions.removeWhere((element) => element['id'] == id);
    storage.write('subs', subscriptions.toList());
  }

  // ==================================================
  // UI Helpers (Dialogs)
  // ==================================================

  void showSubscribeDialog(BuildContext context, String topic) {
    final selectedInterval = "2h".obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "تنبيهات ذكية: $topic",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final option in [
                    '2h',
                    '4h',
                    '8h',
                    '12h',
                    '16h',
                    '20h',
                    '24h',
                  ])
                    _buildChip(
                      label: "كل ${option.replaceAll('h', '')} ساعة",
                      value: option,
                      groupValue: selectedInterval.value,
                      onSelect: (val) => selectedInterval.value = val,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  addSubscription(topic, selectedInterval.value);
                  Get.back();
                },
                child: const Text(
                  "تفعيل",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildChip({
    required String label,
    required String value,
    required String groupValue,
    required Function(String) onSelect,
  }) {
    final isSelected = value == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          onSelect(value);
        }
      },
      selectedColor: Get.theme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : Get.theme.textTheme.bodyMedium?.color,
      ),
    );
  }
}
