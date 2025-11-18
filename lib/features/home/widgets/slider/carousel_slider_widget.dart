import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mega_news/features/home/widgets/slider/featured_article.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';

class CarouselSliderWidget extends StatelessWidget {
  final List<Article> articles;
  const CarouselSliderWidget({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) return const SizedBox.shrink();

    final bool enableAuto = articles.length > 1;

    return SizedBox(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          viewportFraction: 1.0,
          autoPlay: enableAuto,
          enableInfiniteScroll: enableAuto,
        ),
        items: articles.map((a) => FeaturedArticle(article: a)).toList(),
      ),
    );
  }
}
