import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/home/controller/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mega_news/features/home/widgets/build_articles_list.dart';
import 'package:mega_news/features/home/widgets/build_carousel_shimmer.dart';
import 'package:mega_news/features/notifications/presentation/pages/notifications_page.dart';
import 'package:mega_news/features/search/pages/show_search_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      backgroundColor: context.background,
      body: Obx(() {
        // =================================
        // Empty State (when not loading)
        // =================================
        if (!controller.isLoading.value && controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: context.primary.withOpacity(0.3),
                ),
                AppGaps.h16,
                Text(
                  s.home_no_news,
                  style: context.textStyles.headlineSmall?.copyWith(
                    color: context.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppGaps.h8,
                Text(
                  s.home_try_diff_category,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.onBackground.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        // =================================
        // Main Content:
        // =================================
        return RefreshIndicator(
          color: context.primary,
          onRefresh: () => controller.fetchNews(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Sliver AppBar
              SliverAppBar(
                backgroundColor: context.background,
                elevation: 0,
                pinned: true,
                floating: true,
                snap: true,
                expandedHeight: 160,

                leading: LayoutBuilder(
                  builder: (context, constraints) {
                    final settings = context
                        .dependOnInheritedWidgetOfExactType<
                          FlexibleSpaceBarSettings
                        >();
                    final collapsed =
                        settings != null &&
                        settings.currentExtent <= settings.minExtent + 10;

                    return collapsed
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Image.asset(
                              AppImages.logo,
                              width: 28,
                              height: 28,
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),

                actions: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final settings = context
                          .dependOnInheritedWidgetOfExactType<
                            FlexibleSpaceBarSettings
                          >();
                      final collapsed =
                          settings != null &&
                          settings.currentExtent <= settings.minExtent + 10;

                      return Row(
                        children: [
                          if (collapsed)
                            IconButton(
                              icon: Icon(
                                Icons.search_rounded,
                                color: context.onBackground,
                              ),
                              onPressed: () {
                                Get.to(() => const ShowSearchPage());
                              },
                            ),

                          IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              color: context.onBackground,
                            ),
                            onPressed: () {
                              Get.to(() => const NotificationsPage());
                            },
                          ),

                          AppGaps.w8,
                        ],
                      );
                    },
                  ),
                ],

                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final settings = context
                        .dependOnInheritedWidgetOfExactType<
                          FlexibleSpaceBarSettings
                        >();
                    final collapsed =
                        settings != null &&
                        settings.currentExtent <= settings.minExtent + 10;

                    return FlexibleSpaceBar(
                      titlePadding: EdgeInsets.zero,
                      background: SafeArea(
                        bottom: false,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: collapsed ? 0 : 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppGaps.h12,

                                // Greeting
                                Text(
                                  s.home_welcome_back,
                                  style: context.textStyles.labelSmall
                                      ?.copyWith(
                                        color: context.onBackground.withOpacity(
                                          0.6,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                AppGaps.h4,
                                Text(
                                  s.app_name,
                                  style: context.textStyles.headlineLarge
                                      ?.copyWith(
                                        color: context.onBackground,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.8,
                                      ),
                                ),

                                AppGaps.h16,

                                // BIG Search Bar
                                Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: context.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.onBackground.withOpacity(
                                          0.08,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Get.to(() => const ShowSearchPage());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.search_rounded,
                                            color: context.primary.withOpacity(
                                              0.8,
                                            ),
                                          ),
                                          AppGaps.w12,
                                          Expanded(
                                            child: Text(
                                              s.home_search_hint,
                                              style: context
                                                  .textStyles
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: context.onBackground
                                                        .withOpacity(0.6),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 2. Sliver List
              SliverList(
                delegate: SliverChildListDelegate([
                  // Category Chips
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: controller.categories.length,
                      itemBuilder: (_, index) {
                        final cat = controller.categories[index];
                        final isSelected =
                            controller.selectedCategory.value == cat['value'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(
                              cat['label']!, // Label is already localized in controller
                              style: context.textStyles.labelSmall?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? context.onPrimary
                                    : context.onBackground,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) =>
                                controller.changeCategory(cat['value']!),
                            backgroundColor: context.surface,
                            selectedColor: context.primary,
                            checkmarkColor: context.onPrimary,
                            elevation: 0,
                            pressElevation: 4,
                          ),
                        );
                      },
                    ),
                  ),
                  AppGaps.h24,

                  // Featured Carousel
                  controller.isLoading.value
                      ? buildCarouselShimmer(context)
                      : CarouselSlider(
                          items: controller.articles.take(5).map((article) {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  AppPages.articleDetailPage,
                                  arguments: article,
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.grey.shade300,
                                ),
                                child: article.imageUrl == null
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            article.title,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: article.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(0.8),
                                                  Colors.black.withOpacity(0.4),
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: context.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: context.primary
                                                              .withOpacity(0.4),
                                                          blurRadius: 8,
                                                          spreadRadius: 1,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Text(
                                                      s.home_featured_label,
                                                      style: TextStyle(
                                                        color:
                                                            context.onPrimary,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  AppGaps.h12,
                                                  Text(
                                                    article.title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      height: 1.3,
                                                      shadows: [
                                                        Shadow(
                                                          color: Colors.black45,
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  AppGaps.h8,
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      article.sourceName,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 250,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            viewportFraction: 1.0,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            autoPlayCurve: Curves.fastOutSlowIn,
                          ),
                        ),
                  AppGaps.h24,

                  // Latest Articles Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: context.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.article_outlined,
                            size: 18,
                            color: context.primary,
                          ),
                        ),
                        AppGaps.w8,
                        Text(
                          s.home_latest_articles,
                          style: context.textStyles.headlineSmall?.copyWith(
                            color: context.onBackground,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Latest Articles List
                  buildArticlesList(controller, context),

                  // Loading More Indicator
                  Obx(() {
                    if (controller.isLoadingMore.value) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: context.primary,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  AppGaps.h16,
                ]),
              ),
            ],
          ),
        );
      }),
    );
  }
}
