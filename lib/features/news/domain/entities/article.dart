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

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      sourceName: json['sourceName'] as String,
      articleUrl: json['articleUrl'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'sourceName': sourceName,
      'articleUrl': articleUrl,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
