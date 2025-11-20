import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/briefing/controller/briefing_controller.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

Widget buildSmartTopicCard(
  BuildContext context,
  Article displayArticle,
  int index,
  Map<String, String> topicMap,
  AiBriefingController controller,
) {
  final topicId = topicMap['value']!;

  return TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutQuart,
    tween: Tween(begin: 0.0, end: 1.0),
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, 50 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      );
    },
    child: GestureDetector(
      // Tap anywhere on the card (except specific buttons) to open or generate
      onTap: () => controller.selectAndSummarizeTopic(topicMap),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Image
              Hero(
                tag: displayArticle.id,
                child: Image.asset(
                  displayArticle.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: context.primary.withOpacity(0.1)),
                ),
              ),

              // 2. Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // 3. Smart Content with Obx
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Obx(() {
                  final isLoading = controller.loadingTopicIds.contains(
                    topicId,
                  );
                  final isCached = controller.cachedSummaries.containsKey(
                    topicId,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Row: Status Badge & Refresh Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Status Badge
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: isLoading ? 8 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: isLoading
                                  ? context.primary.withOpacity(0.9)
                                  : (isCached
                                        ? Colors.green.withOpacity(
                                            0.9,
                                          ) // Ready State
                                        : Colors.white.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isLoading || isCached
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLoading)
                                  const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                else
                                  Icon(
                                    isCached
                                        ? Icons.check_circle
                                        : Icons.auto_awesome_outlined,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                AppGaps.h8,
                                Text(
                                  isLoading
                                      ? 'Analyzing...'
                                      : (isCached
                                            ? 'Briefing Ready'
                                            : 'Generate Summary'),
                                  style: context.textStyles.labelSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Force Refresh Button (Only shows if cached)
                          if (isCached && !isLoading)
                            GestureDetector(
                              onTap: () => controller.selectAndSummarizeTopic(
                                topicMap,
                                forceRefresh: true,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Bottom Row: Title & Action Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              displayArticle.title.toUpperCase(),
                              style: context.textStyles.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                    height: 1.0,
                                  ),
                            ),
                          ),

                          // Action Button (Dynamic Color)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isLoading
                                  ? Colors.white
                                  : (isCached ? Colors.green : context.primary),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isCached
                                              ? Colors.green
                                              : context.primary)
                                          .withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: context.primary,
                                    ),
                                  )
                                : Icon(
                                    isCached
                                        ? Icons.menu_book_rounded
                                        : Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
