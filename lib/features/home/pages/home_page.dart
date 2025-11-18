import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/home/controller/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            FlutterLogo(size: 40),
            SizedBox(width: 8),
            Text('Mega News', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // =================================
          // Loading State
          // =================================
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // =================================
          // Empty State
          // =================================
          if (controller.articles.isEmpty) {
            return const Center(child: Text('No news found'));
          }

          // =================================
          // Data State
          // =================================
          return RefreshIndicator(
            onRefresh: () => controller.fetchNews(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!controller.isLoadingMore.value &&
                    controller.hasMorePages.value &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent * 0.8) {
                  controller.loadMore();
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==============================
                    // Category Chips
                    // ==============================
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        itemBuilder: (_, index) {
                          final cat = controller.categories[index];
                          final isSelected =
                              controller.selectedCategory.value == cat['value'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat['label']!),
                              selected: isSelected,
                              onSelected: (_) =>
                                  controller.changeCategory(cat['value']!),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ==============================
                    // Featured Carousel
                    // ==============================
                    CarouselSlider(
                      items: controller.articles.take(5).map((article) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              article.title,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 200,
                        enlargeCenterPage: true,
                        autoPlay: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ==============================
                    // Latest Articles
                    // ==============================
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (controller.articles.length > 5)
                          ? controller.articles.length - 5
                          : 0,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final article = controller.articles[index + 5];
                        return ListTile(
                          title: Text(article.title),
                          subtitle: Text(article.sourceName),
                        );
                      },
                    ),

                    // ==============================
                    // Loading More Indicator
                    // ==============================
                    Obx(() {
                      if (controller.isLoadingMore.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
