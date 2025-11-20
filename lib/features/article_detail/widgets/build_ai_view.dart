import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';

Widget buildAiView(
  BuildContext context,
  Color dynamicColor,
  ArticleDetailController controller,
) {
  return CustomScrollView(
    physics: const BouncingScrollPhysics(),
    slivers: [
      // ================= Header Section =================
      SliverAppBar(
        pinned: true,
        backgroundColor: context.background,
        elevation: 0,
        title: Text(
          context.s.title_ai_summary,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.primary),
          onPressed: () => Get.back(),
        ),
      ),

      // ================= Content Body =================
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            // --- 1. Topic Title ---
            Text(
              controller.aiTopic ?? context.s.label_smart_insight,
              style: context.textStyles.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: dynamicColor,
              ),
            ),

            AppGaps.h16,
            // --- 2. AI Images Grid (2x2) ---
            if (controller.aiImages != null && controller.aiImages!.isNotEmpty)
              Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.3,
                        ),
                    itemCount: controller.aiImages!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            controller.aiImages![index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: context.onBackground.withOpacity(0.1),
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: context.onBackground.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AppGaps.h24,
                ],
              ),

            Divider(color: context.onBackground.withOpacity(0.1)),
            AppGaps.h16,
            // --- 4. Summary Text ---
            Text(
              controller.aiSummary ?? context.s.status_generating_summary,
              style: context.textStyles.bodyLarge?.copyWith(
                fontSize: 17,
                height: 1.6,
                color: context.onBackground.withOpacity(0.8),
              ),
            ),

            AppGaps.h32,
            // ================= Action Buttons =================

            // TTS Button (Wrapped in Obx to update UI on state change)
            Center(
              child: Obx(() {
                final isPlaying = controller.ttsState.value == TtsState.playing;

                return FloatingActionButton.extended(
                  heroTag: 'tts_button',
                  onPressed: () {
                    if (isPlaying) {
                      controller.stopTts();
                    } else {
                      controller.speak();
                    }
                  },
                  backgroundColor: dynamicColor,
                  elevation: 4,
                  highlightElevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isPlaying
                          ? Icons.stop_rounded
                          : Icons.record_voice_over_rounded,
                      key: ValueKey(isPlaying),
                      color: Colors.white,
                    ),
                  ),
                  label: Text(
                    isPlaying
                        ? context.s.action_stop_listening
                        : context.s.action_listen_summary,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              }),
            ),

            AppGaps.h32,
            AppGaps.h32,
          ]),
        ),
      ),
    ],
  );
}
