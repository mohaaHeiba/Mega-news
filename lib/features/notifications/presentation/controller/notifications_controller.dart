import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/custom/custom_snackbar.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:workmanager/workmanager.dart';

// ************************************************
// 💡 ملاحظة: يجب عليك توفير ملفات/إضافات AppLocalizations
// في مشروعك للوصول إلى الترجمة بالطريقة التالية.
// تم افتراض استخدام AppLocalizations.of(context)!
// ************************************************

class NotificationsController extends GetxController {
  var subscriptions = <Map<String, dynamic>>[].obs;
  final storage = GetStorage();

  // 🗑️ تم حذف: final s = Get.context!.s; (لن نعتمد على GetX للترجمة)

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

  void addSubscription(String topic, String interval, BuildContext context) {
    // 💡 يجب تمرير الـ context لاستخدام الترجمة
    final loc = context.s;

    if (subscriptions.any((element) => element['topic'] == topic)) {
      customSnackbar(
        title: loc.error, // 💡 تم التغيير
        message: loc.u_in, // 💡 تم التغيير
        color: AppColors.warning,
      );
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

    final hours = int.tryParse(interval.replaceAll('h', '')) ?? 2;
    final frequency = Duration(hours: hours);

    Workmanager().registerPeriodicTask(
      uniqueTaskName,
      "fetch_news_task",
      frequency: frequency,
      inputData: {'topic': topic, 'lang': Get.locale?.languageCode ?? 'en'},
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    // 💡 إصلاح الرسالة لتعكس المتغيرات بشكل صحيح:
    Get.snackbar(
      loc.subscription_success_title, // 💡 تم التغيير
      "${loc.subscriptions_receive_summary} $topic ${loc.subscriptions_receive_summary2} $hours ${loc.hour}", // 💡 تم التغيير وإصلاح دمج النصوص
    );
  }

  void removeSubscription(String id, String topic) {
    final sub = subscriptions.firstWhere(
      (e) => e['id'] == id,
      orElse: () => {},
    );

    if (sub.isNotEmpty) {
      Workmanager().cancelByUniqueName(sub['taskName']);
      debugPrint(
        "🛑 Task Cancelled: ${sub['taskName']}",
      ); // استخدام debugPrint بدلاً من print
    }

    subscriptions.removeWhere((element) => element['id'] == id);
    storage.write('subs', subscriptions.toList());
  }

  // ==================================================
  // UI Helpers (Dialogs)
  // ==================================================

  void showSubscribeDialog(BuildContext context, String topic) {
    final selectedInterval = "2h".obs;
    final loc = context.s; // 💡 الوصول إلى الترجمة

    // 💡 قائمة الخيارات مع مفاتيح الترجمة المقابلة
    final intervalOptions = {
      '2h': loc.interval_2h,
      '4h': loc.interval_4h,
      '8h': loc.interval_8h,
      '12h': loc.interval_12h,
      '16h': loc.interval_16h,
      '20h': loc.interval_20h,
      '24h': loc.interval_24h,
    };

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
              "${loc.smart_alerts_title} $topic", // 💡 تم التغيير
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final entry in intervalOptions.entries)
                    _buildChip(
                      // 💡 استخدام نص الترجمة المناسب مباشرة
                      label: entry.value,
                      value: entry.key,
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
                onPressed: () async {
                  Get.back();
                  // 💡 تمرير الـ context للدالة
                  addSubscription(topic, selectedInterval.value, context);
                },
                child: Text(
                  loc.action_activate, // 💡 تم التغيير
                  style: const TextStyle(color: Colors.white),
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
