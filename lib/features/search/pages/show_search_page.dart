// ملف: ShowSearchPage
import 'package:flutter/material.dart'
    show Scaffold, AppBar, CircularProgressIndicator, IconButton, Icons;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/home/widgets/build_articles_list.dart';
import 'package:mega_news/features/search/controller/search_controller.dart';
import 'package:mega_news/features/search/widgets/build_empty_state.dart';
import 'package:mega_news/features/search/widgets/build_floating_action_button.dart';
import 'package:mega_news/features/search/widgets/build_history_list.dart';
import 'package:mega_news/features/search/widgets/build_search_bar.dart';
import 'package:mega_news/features/search/widgets/voice_search_overlay.dart';

class ShowSearchPage extends GetView<SearchController> {
  const ShowSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s; // Localization helper

    return Scaffold(
      backgroundColor: context.background,
      floatingActionButton: buildFloatingActionButton(context, controller),

      // ==============================================================================
      // AppBar - Simple, No Animation
      // ==============================================================================
      appBar: AppBar(
        backgroundColor: context.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              // Back Button
              IconButton(
                icon: Icon(Icons.arrow_back, color: context.onBackground),
                onPressed: () => Get.back(),
              ),

              const SizedBox(width: 4),

              // Search Bar
              Expanded(child: buildSearchBar(context, controller)),

              const SizedBox(width: 4),

              // Voice Search Button
              IconButton(
                icon: Icon(Icons.mic_none_rounded, color: context.onBackground),
                onPressed: controller.startListening,
              ),

              Obx(() {
                final isSearching = controller.searchQuery.value.isNotEmpty;
                return isSearching
                    ? IconButton(
                        icon: Icon(
                          Icons.notifications_none_rounded,
                          color: context.onBackground,
                        ),
                        onPressed: () async {
                          controller.subscribeToCurrentTopic(context);
                        },
                      )
                    : SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          // ==============================================================================
          // Main Scrollable Content
          // ==============================================================================
          NotificationListener<ScrollNotification>(
            // Handle Pagination (Load More)
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoadingMore.value &&
                  controller.hasMorePages.value &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                controller.loadMore();
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                // Content Body (States)
                Obx(() {
                  if (controller.isLoading.value) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: buildArticlesList(
                          controller,
                          context,
                          skipFirstFive: false,
                        ),
                      ),
                    );
                  }

                  if (controller.searchQuery.value.isEmpty) {
                    if (controller.searchHistory.isNotEmpty) {
                      return SliverToBoxAdapter(
                        child: buildHistoryList(context, s, controller),
                      );
                    } else {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: buildEmptyState(
                          context,
                          icon: Icons.travel_explore_rounded,
                          message: s.search_discover,
                          iconColor: context.primary,
                        ),
                      );
                    }
                  }

                  if (controller.articles.isEmpty &&
                      controller.searchQuery.value.isNotEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: buildEmptyState(
                        context,
                        icon: Icons.search_off_rounded,
                        message: s.search_no_results,
                      ),
                    );
                  }

                  // Results List
                  return SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Results Count Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                          child: Row(
                            children: [
                              Text(
                                '${controller.articles.length} ${s.search_results_count}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: context.primary,
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: Text(
                                  '${s.search_results_for} "${controller.searchQuery.value}"',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.onBackground.withOpacity(
                                      0.6,
                                    ),
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Articles List
                        buildArticlesList(
                          controller,
                          context,
                          skipFirstFive: false,
                        ),

                        // Bottom Loader (Pagination)
                        if (controller.isLoadingMore.value)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          AppGaps.h24,
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // ==============================================================================
          // Voice Search Overlay (Listening Mode)
          // ==============================================================================
          Obx(() {
            if (controller.isListening.value) {
              return voiceSearchOverlay(controller, s);
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
