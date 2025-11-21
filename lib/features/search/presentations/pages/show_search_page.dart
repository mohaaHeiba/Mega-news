import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
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
    final s = context.s;

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
                  // ===================================================
                  // ✅ AppBar with Notification Action
                  // ===================================================
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: context.background,
                    floating: true,
                    snap: true,
                    pinned: false,
                    expandedHeight: 0,
                    toolbarHeight: 90,
                    automaticallyImplyLeading: false,
                    // شريط البحث
                    title: buildSearchBar(context, controller),

                    // ✅✅ إضافة زر الإشعارات هنا ✅✅
                    actions: [
                      Obx(() {
                        // يظهر الزر فقط لو فيه كلمة بحث مكتوبة
                        if (controller.searchQuery.value.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsetsDirectional.only(end: 16),
                            child: IconButton(
                              icon: Icon(
                                Icons.notification_add_outlined,
                                color: context.primary,
                              ),
                              tooltip: 'asd', // تأكد من إضافتها في الترجمة
                              onPressed: () {
                                controller.subscribeToCurrentTopic(context);
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
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

                    // 2. Initial State (History OR Discover)
                    if (controller.searchQuery.value.isEmpty) {
                      // ✅ عرض الهيستوري لو موجود
                      if (controller.searchHistory.isNotEmpty) {
                        return SliverToBoxAdapter(
                          child: _buildHistoryList(context, s),
                        );
                      } else {
                        // عرض شاشة الاكتشاف
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

                    // 3. Empty State (No Results found)
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
                            AppGaps.h24,
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
                        AppGaps.h32,
                        Text(
                          s.search_listening,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        AppGaps.h12,
                        Text(
                          s.search_listening_hint,
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

  // ==========================================
  // ✅ Widget لعرض قائمة السجل
  // ==========================================
  Widget _buildHistoryList(BuildContext context, var s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.search_recent,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.onBackground,
                ),
              ),
              TextButton(
                onPressed: controller.clearAllHistory,
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                child: Text(s.search_clear_all),
              ),
            ],
          ),
        ),
        ...controller.searchHistory.map(
          (item) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(
                Icons.history_rounded,
                color: context.onBackground.withOpacity(0.5),
                size: 22,
              ),
              title: Text(
                item,
                style: TextStyle(fontSize: 16, color: context.onBackground),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: context.onBackground.withOpacity(0.4),
                  size: 20,
                ),
                onPressed: () => controller.removeFromHistory(item),
              ),
              onTap: () => controller.searchFromHistory(item),
            );
          },
        ).toList(), // شيلت toList هنا لأن الـ spread operator بيحتاج iterable بس toList أأمن
        AppGaps.h24,
      ],
    );
  }
}
