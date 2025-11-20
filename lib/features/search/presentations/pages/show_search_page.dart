import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/home/widgets/build_articles_list.dart';
import 'package:mega_news/features/search/presentations/controller/search_controller.dart';
import 'package:mega_news/features/search/presentations/widgets/build_empty_state.dart';
import 'package:mega_news/features/search/presentations/widgets/build_floating_action_button.dart';
import 'package:mega_news/features/search/presentations/widgets/build_search_bar.dart';

class ShowSearchPage extends GetView<SearchController> {
  const ShowSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      floatingActionButton: buildFloatingActionButton(context, controller),
      body: Stack(
        children: [
          // 1. Main Content
          SafeArea(
            child: NotificationListener<ScrollNotification>(
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
                  // AppBar
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: context.background,
                    floating: true,
                    snap: true,
                    pinned: false,
                    expandedHeight: 0,
                    toolbarHeight: 90,
                    automaticallyImplyLeading: false,
                    title: buildSearchBar(context, controller),
                  ),

                  // Content Body
                  Obx(() {
                    // 1. Loading State
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

                    // 2. Initial State (Discover - Search Query is Empty)
                    if (controller.searchQuery.value.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: buildEmptyState(
                          context,
                          icon: Icons.travel_explore_rounded,
                          message: 'Discover News',
                          iconColor: context.primary,
                        ),
                      );
                    }

                    // 3. Empty State (No Results found when searching)
                    if (controller.articles.isEmpty &&
                        controller.searchQuery.value.isNotEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: buildEmptyState(
                          context,
                          icon: Icons.search_off_rounded,
                          message: 'No results found',
                        ),
                      );
                    }

                    // 4. Results List
                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                            child: Row(
                              children: [
                                Text(
                                  '${controller.articles.length} Results',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: context.primary,
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Text(
                                    'for "${controller.searchQuery.value}"',
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
                          buildArticlesList(
                            controller,
                            context,
                            skipFirstFive: false,
                          ),
                          if (controller.isLoadingMore.value)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else
                            const SizedBox(height: 24),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // 2. Mic Overlay
          Obx(() {
            if (controller.isListening.value) {
              return Positioned.fill(
                child: GestureDetector(
                  onTap: controller.stopListening,
                  child: Container(
                    color: Colors.black.withOpacity(0.85),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.6),
                                blurRadius: 50,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mic_rounded,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "Listening...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Try saying 'Sports' or 'Technology'",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
