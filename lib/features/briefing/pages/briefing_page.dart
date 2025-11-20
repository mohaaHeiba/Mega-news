import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/briefing/controller/briefing_controller.dart';
import 'package:mega_news/features/briefing/widgets/build_smart_topic_card.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class AiBriefingPage extends GetView<AiBriefingController> {
  const AiBriefingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final topics = controller.staticTopics;
    final todayDate = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: context.background,
      body: CustomScrollView(
        slivers: [
          // --- AppBar ---
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: context.background,
            surfaceTintColor: context.background,
            elevation: 0,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              expandedTitleScale: 1.2,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  AppGaps.h8,
                  Text(
                    s.briefing,
                    style: context.textStyles.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.onBackground,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.primary.withOpacity(0.5),
                      context.primary.withOpacity(0.5),
                      context.background,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayDate.toUpperCase(),
                        style: context.textStyles.labelMedium?.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      AppGaps.h8,

                      Text(
                        s.ai_welcome_message,
                        style: context.textStyles.headlineMedium?.copyWith(
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: context.onBackground.withOpacity(0.8),
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- List View ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final topicMap = topics[index];
                // We use only basic info for display, real data comes from cache or API
                final displayArticle = Article(
                  id: topicMap['value']!,
                  title: topicMap['label']!,
                  imageUrl: topicMap['image'],
                  description: '',
                  sourceName: '',
                  publishedAt: DateTime.now(),
                  articleUrl: '',
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: buildSmartTopicCard(
                    context,
                    displayArticle,
                    index,
                    topicMap,
                    controller,
                  ),
                );
              }, childCount: topics.length),
            ),
          ),
        ],
      ),
    );
  }
}
