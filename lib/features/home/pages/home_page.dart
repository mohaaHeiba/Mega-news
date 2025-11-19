import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/home/controller/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mega_news/features/home/widgets/build_article_shimmer.dart';
import 'package:mega_news/features/home/widgets/build_carousel_shimmer.dart';
import 'package:mega_news/features/search/presentations/pages/show_search_page.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: Obx(() {
        // =================================
        // Empty State (when not loading)
        // =================================
        if (!controller.isLoading.value && controller.articles.isEmpty) {
          // ... (Empty State Code remains unchanged) ...
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: context.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No news found',
                  style: context.textStyles.headlineSmall?.copyWith(
                    color: context.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try selecting a different category',
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
                  // Search shows ONLY when collapsed
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
                          // Search button - only when collapsed
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

                          // Notifications - always visible
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              color: context.onBackground,
                            ),
                            onPressed: () {},
                          ),

                          const SizedBox(width: 8),
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
                                const SizedBox(height: 12),

                                // Greeting
                                Text(
                                  'Welcome Back,',
                                  style: context.textStyles.labelSmall
                                      ?.copyWith(
                                        color: context.onBackground.withOpacity(
                                          0.6,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Mega News.',
                                  style: context.textStyles.headlineLarge
                                      ?.copyWith(
                                        color: context.onBackground,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.8,
                                      ),
                                ),

                                const SizedBox(height: 16),

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
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Search over 1,000,000 articles...',
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
              // 2. Sliver List (يحتوي على باقي محتوى الصفحة)
              SliverList(
                delegate: SliverChildListDelegate([
                  // AppGaps.h12, // مسافة علوية
                  // Category Chips (تبقى كما هي)
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
                              cat['label']!,
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

                  // Featured Carousel (تبقى كما هي)
                  controller.isLoading.value
                      ? buildCarouselShimmer(context)
                      : CarouselSlider(
                          items: controller.articles.take(5).map((article) {
                            // ... (Carousel Item Code remains unchanged) ...
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
                                  image: article.imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            article.imageUrl ?? '',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
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
                                                      '⚡ FEATURED',
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
                                                  const SizedBox(height: 12),
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
                                                  const SizedBox(height: 8),
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
                  const SizedBox(height: 20),

                  // Latest Articles Header (تبقى كما هي)
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
                        const SizedBox(width: 10),
                        Text(
                          'Latest Articles',
                          style: context.textStyles.headlineSmall?.copyWith(
                            color: context.onBackground,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Latest Articles List (تم تحديثها في الطلب السابق)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: controller.isLoading.value
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (_, __) =>
                                buildArticleShimmer(context),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (controller.articles.length > 5)
                                ? controller.articles.length - 5
                                : 0,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 0),
                            itemBuilder: (_, index) {
                              final article = controller.articles[index + 5];

                              // ... (Article Item Code from the last refined version) ...
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      AppPages.articleDetailPage,
                                      arguments: article,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 1. Article Image (Prominent, Left Side, Ratio 4:3)
                                            if (article.imageUrl != null)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  article.imageUrl ?? '',
                                                  width: 100,
                                                  height:
                                                      75, // ارتفاع أقل لنسبة 4:3 تقريبًا
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => Container(
                                                    width: 100,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      color: context.primary
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .image_not_supported_rounded,
                                                      color: context.primary
                                                          .withOpacity(0.5),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            if (article.imageUrl != null)
                                              const SizedBox(width: 12),

                                            // 2. Article Content (Right Side - Title is the Focus)
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    article.title,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: context
                                                        .textStyles
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight: FontWeight
                                                              .w800, // خط سميك جداً للعنوان
                                                          height: 1.3,
                                                          color: context
                                                              .onBackground,
                                                        ),
                                                  ),

                                                  // Source Name (Immediately below the title, low contrast)
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    article.sourceName,
                                                    style: context
                                                        .textStyles
                                                        .labelMedium
                                                        ?.copyWith(
                                                          color: context
                                                              .onBackground
                                                              .withOpacity(0.6),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        // 3. Bottom Metadata & Actions Row (Cleaned up, full width)
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Time (Primary Metadata)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  size: 14,
                                                  color: context.primary
                                                      .withOpacity(0.8),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  controller.getTimeAgo(
                                                    article.publishedAt,
                                                  ),
                                                  style: context
                                                      .textStyles
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: context.primary
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),

                                            // Actions (Grouped, using IconButton for better tap area)
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.share_rounded,
                                                    size: 20,
                                                    color: context.onBackground
                                                        .withOpacity(0.5),
                                                  ),
                                                  onPressed: () {
                                                    Share.share(
                                                      "${article.title}\n${article.articleUrl}",
                                                    );
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32,
                                                      ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    controller.isLiked.value
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color:
                                                        controller.isLiked.value
                                                        ? Colors.redAccent
                                                        : Colors.white,
                                                    size: 18,
                                                  ),
                                                  onPressed: () => controller
                                                      .isLiked
                                                      .toggle(),

                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // Divider to separate items
                                        const SizedBox(height: 8),
                                        Divider(
                                          color: context.onBackground
                                              .withOpacity(0.1),
                                          height: 1,
                                          thickness: 0.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

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
                  const SizedBox(height: 20),
                ]),
              ),
            ],
          ),
        );
      }),
    );
  }
}
