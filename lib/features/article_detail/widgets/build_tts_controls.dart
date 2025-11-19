import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';

Widget buildTtsControls(
  BuildContext context,
  Color dynamicColor,
  ArticleDetailController controller,
) {
  final theme = Theme.of(context);
  return Obx(() {
    final state = controller.ttsState.value;
    if (state == TtsState.playing || state == TtsState.continued) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: controller.stopTts,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.stop_rounded,
                size: 20,
                color: Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: controller.pauseTts,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.pause_rounded, size: 16, color: dynamicColor),
                  const Text(
                    " Pause",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return InkWell(
        onTap: controller.speak,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.volume_up_rounded, size: 16, color: dynamicColor),
              const Text(
                " Listen",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }
  });
}
