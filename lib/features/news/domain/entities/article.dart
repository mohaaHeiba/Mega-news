import 'package:flutter/foundation.dart';

@immutable
class Article {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String sourceName;
  final String articleUrl;
  final DateTime publishedAt;

  const Article({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.sourceName,
    required this.articleUrl,
    required this.publishedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
