import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/welcome/controllers/welcome_controller.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final appTheme = context;
    final pages = controller.pages;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: appTheme.background,
      // ========== AppBar ==========
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 60),
            AppGaps.w8,
            Text(
              'MegaNews',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => controller.currentIndex.value < pages.length - 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: TextButton(
                      onPressed: () {
                        controller.imageController.animateToPage(
                          pages.length - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        s.skip,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: appTheme.onSurface,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      // ========== Body ==========
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primary.withOpacity(0.5),
              context.background,
              context.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight + context.mediaQuery.padding.top),
            AppGaps.h12,
            // ===== Images =====
            SizedBox(
              width: double.infinity,
              height: context.screenHeight * 0.4,
              child: PageView.builder(
                controller: controller.imageController,
                onPageChanged: controller.onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Image.asset(pages[index]["image"]!, fit: BoxFit.cover);
                },
              ),
            ),
            AppGaps.h24,
            // --- Start of Edits ---
            Expanded(
              child: Obx(
                () => AnimatedSlide(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  offset: controller.showContent.value
                      ? Offset.zero
                      : const Offset(0, 0.3),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: controller.showContent.value ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Obx(() {
                                final page =
                                    pages[controller.currentIndex.value];
                                return Column(
                                  children: [
                                    Text(
                                      page["title"]!,
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    AppGaps.h12,
                                    Text(
                                      page["subtitle"]!,
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        // ===== Cursor (Page Indicator) =====
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                pages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: controller.currentIndex.value == index
                                      ? 28
                                      : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.currentIndex.value == index
                                        ? appTheme.primary
                                        : appTheme.primary.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // ===== Buttons =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (controller.currentIndex.value <
                                      pages.length - 1) {
                                    controller.imageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    await GetStorage().write(
                                      'seenWelcome',
                                      true,
                                    );
                                    await controller.requestPermissions();
                                    await Get.offNamed(AppPages.authPage);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appTheme.primary,
                                  foregroundColor: appTheme.onPrimary,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.currentIndex.value ==
                                              pages.length - 1
                                          ? s.getStarted
                                          : s.next,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // AppGaps.w4,
                                    // Icon(
                                    //   controller.currentIndex.value ==
                                    //           pages.length - 1
                                    //       ? Icons.rocket_launch_rounded
                                    //       : Icons.arrow_forward,
                                    //   size: 20,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppGaps.h32,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
