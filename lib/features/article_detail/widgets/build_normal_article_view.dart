import 'dart:ui'; // Needed for ImageFilter (Blur)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/article_detail/controller/article_detail_controller.dart';
import 'package:mega_news/features/article_detail/widgets/build_tts_controls.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget buildNormalArticleView(
  BuildContext context,
  Color dynamicColor,
  ArticleDetailController controller,
) {
  final article = controller.article!;

  return CustomScrollView(
    physics: const BouncingScrollPhysics(),
    slivers: [
      // ================= Sliver App Bar (Image & Nav) =================
      SliverAppBar(
        expandedHeight: 320,
        pinned: true,
        stretch: true,
        backgroundColor: context.background,

        // --- Leading Back Button (Frosted Glass) ---
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),

        // --- Action Buttons (Share & Like) ---
        actions: [
          _buildGlassActionButton(
            icon: Icons.share_rounded,
            onTap: () => Share.share("${article.title}\n${article.articleUrl}"),
          ),
          AppGaps.h8,
          Obx(
            () => _buildGlassActionButton(
              icon: controller.isLiked.value
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: controller.isLiked.value ? Colors.redAccent : Colors.white,
              onTap: () => controller.toggleLike(),
            ),
          ),
          AppGaps.h16,
        ],

        // --- Background Image & Gradient ---
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: const [
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
          ],
          background: Stack(
            fit: StackFit.expand,
            children: [
              // 1. The Main Image
              Hero(
                tag: article.imageUrl ?? article.title,
                child: _buildSmartImage(context, article.imageUrl),
              ),

              // 2. Gradient Overlay (For text readability)
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black26,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // 3. Source Badge (Bottom Left)
              Positioned(
                bottom: 16,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: dynamicColor, // Uses the extracted vibrant color
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.newspaper_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      AppGaps.h8,
                      Text(
                        article.sourceName,
                        style: context.textStyles.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= Article Content Body =================
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Title ---
              Text(
                article.title,
                style: context.textStyles.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                  color: context.onBackground,
                ),
              ),

              AppGaps.h16, // Using AppGaps
              // --- 2. Metadata Row (Time & TTS) ---
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: context.onBackground.withOpacity(0.6),
                  ),
                  AppGaps.h8,
                  Text(
                    timeago.format(article.publishedAt),
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.onBackground.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  // TTS Widget (Passed from parameters)
                  buildTtsControls(context, dynamicColor, controller),
                ],
              ),

              AppGaps.h24,
              Divider(
                color: context.onBackground.withOpacity(0.1),
                thickness: 1,
              ),
              AppGaps.h24,

              // --- 3. Description Text ---
              Text(
                article.description ?? context.s.msg_no_description,
                style: context.textStyles.bodyLarge?.copyWith(
                  fontSize: 17,
                  height: 1.7,
                  color: context.onBackground.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

// ================= Helper Widgets =================

Widget _buildGlassActionButton({
  required IconData icon,
  required VoidCallback onTap,
  Color color = Colors.white,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.3),
      shape: BoxShape.circle,
    ),
    child: ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: color, size: 20),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildSmartImage(BuildContext context, String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      color: context.surface,
      child: Icon(
        Icons.broken_image_rounded,
        size: 50,
        color: context.onSurface.withOpacity(0.2),
      ),
    );
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    memCacheWidth: 800,

    // Loading placeholder
    placeholder: (context, url) => Container(
      color: context.surface.withOpacity(0.15),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
    ),

    // Error image
    errorWidget: (context, url, error) => Container(
      color: context.surface,
      child: Icon(
        Icons.broken_image_rounded,
        color: context.onSurface.withOpacity(0.3),
        size: 40,
      ),
    ),
  );
}
