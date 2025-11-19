import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';

Widget buildArticleView(
  BuildContext context,
  BuildContext theme,
  ArticleDetailController controller,
  final article,
) {
  return Scaffold(
    backgroundColor: theme.colors.surface,

    //  Bottom Bar
    bottomNavigationBar: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          final dynamicColor =
              controller.vibrantColor.value != Colors.transparent
              ? controller.vibrantColor.value
              : Colors.transparent;

          return SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text(
                'Read Full Story',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: dynamicColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: controller.openArticleLink,
            ),
          );
        }),
      ),
    ),

    body: Obx(() {
      final dynamicColor = controller.vibrantColor.value != Colors.transparent
          ? controller.vibrantColor.value
          : Colors.transparent;

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: theme.colors.surface,
            leading: IconButton(
              icon: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black38,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black38,
                  child: Icon(Icons.share, color: Colors.white, size: 18),
                ),
                onPressed: () {
                  Share.share("${article!.title}\n${article!.articleUrl}");
                },
              ),
              // 🔹 هنا التصحيح
              Obx(
                () => IconButton(
                  icon: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black38,
                    child: Icon(
                      controller.isLiked.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: controller.isLiked.value
                          ? Colors.redAccent
                          : Colors.white,
                      size: 18,
                    ),
                  ),
                  onPressed: () => controller.toggleLike(),
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: article!.id,
                    child: Image.network(
                      article!.imageUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                          Colors.black87,
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: dynamicColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        article!.sourceName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article!.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: theme.colors.onSurface,
                    ),
                  ),

                  AppGaps.h12,

                  // 🔹 الصف الخاص بالوقت وأزرار التحكم (Logic Updated)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeago.format(article!.publishedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),

                      // 🔴 هنا التغيير: عرض الأزرار حسب الحالة
                      Obx(() {
                        final state = controller.ttsState.value;

                        // الحالة 1: جاري التحدث (نعرض Pause و Stop)
                        if (state == TtsState.playing ||
                            state == TtsState.continued) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // زر Stop
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: controller.stopTts,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.redAccent.withOpacity(0.5),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.stop_rounded,
                                    size: 20,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // زر Pause
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: controller.pauseTts,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colors.surfaceContainerHighest
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: theme.colors.outlineVariant
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.pause_rounded,
                                        size: 16,
                                        color: dynamicColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Pause",
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme.colors.onSurface,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        // الحالة 2: متوقف مؤقتاً (نعرض Resume و Stop)
                        else if (state == TtsState.paused) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // زر Stop
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: controller.stopTts,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.redAccent.withOpacity(0.5),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.stop_rounded,
                                    size: 20,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // زر Resume
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: controller
                                    .speak, // استدعاء Speak سيكمل الكلام في معظم الحالات
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: dynamicColor.withOpacity(
                                      0.1,
                                    ), // تمييز خفيف للـ Resume
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: dynamicColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.play_arrow_rounded,
                                        size: 16,
                                        color: dynamicColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Resume",
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme.colors.onSurface,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        // الحالة 3: متوقف تماماً (نعرض Listen فقط)
                        else {
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: controller.speak,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colors.surfaceContainerHighest
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colors.outlineVariant
                                      .withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.volume_up_rounded,
                                    size: 16,
                                    color: dynamicColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Listen",
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.onSurface,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(thickness: 0.5),
                  ),

                  Text(
                    article!.description ??
                        'No content available for this article.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.5,
                      height: 1.6,
                      color: theme.colors.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }),
  );
}
