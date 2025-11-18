// To parse this JSON data, do
//
//     final newsdataResponseModel = newsdataResponseModelFromJson(jsonString);

import 'dart:convert';

NewsdataResponseModel newsdataResponseModelFromJson(String str) =>
    NewsdataResponseModel.fromJson(json.decode(str));

String newsdataResponseModelToJson(NewsdataResponseModel data) =>
    json.encode(data.toJson());

class NewsdataResponseModel {
  final String status;
  final int totalResults;
  final List<NewsDataArticleModel> results;
  final String? nextPage;

  NewsdataResponseModel({
    required this.status,
    required this.totalResults,
    required this.results,
    this.nextPage,
  });

  factory NewsdataResponseModel.fromJson(Map<String, dynamic> json) =>
      NewsdataResponseModel(
        status: json["status"],
        totalResults: json["totalResults"],
        results: List<NewsDataArticleModel>.from(
          json["results"].map((x) => NewsDataArticleModel.fromJson(x)),
        ),
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "nextPage": nextPage,
  };
}

class NewsDataArticleModel {
  final String articleId;
  final String link;
  final String title;
  final String? description;
  final String? content;
  final List<String>? keywords;
  final List<String>? creator;
  final String? language;
  final List<String>? country;
  final List<String>? category;
  final DateTime pubDate;
  final String? pubDateTz;
  final String? imageUrl;
  final dynamic videoUrl;
  final String sourceId;
  final String sourceName;
  final int? sourcePriority;
  final String? sourceUrl;
  final String? sourceIcon;
  final String? sentiment;
  final String? sentimentStats;
  final String? aiTag;
  final String? aiRegion;
  final String? aiOrg;
  final String? aiSummary;
  final bool? duplicate;

  NewsDataArticleModel({
    required this.articleId,
    required this.link,
    required this.title,
    this.description,
    this.content,
    this.keywords,
    this.creator,
    this.language,
    this.country,
    this.category,
    required this.pubDate,
    this.pubDateTz,
    this.imageUrl,
    this.videoUrl,
    required this.sourceId,
    required this.sourceName,
    this.sourcePriority,
    this.sourceUrl,
    this.sourceIcon,
    this.sentiment,
    this.sentimentStats,
    this.aiTag,
    this.aiRegion,
    this.aiOrg,
    this.aiSummary,
    this.duplicate,
  });

  factory NewsDataArticleModel.fromJson(Map<String, dynamic> json) =>
      NewsDataArticleModel(
        articleId: json["article_id"],
        link: json["link"],
        title: json["title"] ?? "No Title",
        description: json["description"],
        content: json["content"],
        keywords: json["keywords"] == null
            ? null
            : List<String>.from(json["keywords"].map((x) => x)),
        creator: json["creator"] == null
            ? null
            : List<String>.from(json["creator"].map((x) => x)),
        language: json["language"],
        country: json["country"] == null
            ? null
            : List<String>.from(json["country"].map((x) => x)),
        category: json["category"] == null
            ? null
            : List<String>.from(json["category"].map((x) => x)),
        pubDate: DateTime.parse(json["pubDate"]),
        pubDateTz: json["pubDateTZ"],
        imageUrl: json["image_url"],
        videoUrl: json["video_url"],
        sourceId: json["source_id"],
        sourceName: json["source_name"],
        sourcePriority: json["source_priority"],
        sourceUrl: json["source_url"],
        sourceIcon: json["source_icon"],
        sentiment: json["sentiment"],
        sentimentStats: json["sentiment_stats"],
        aiTag: json["ai_tag"],
        aiRegion: json["ai_region"],
        aiOrg: json["ai_org"],
        aiSummary: json["ai_summary"],
        duplicate: json["duplicate"],
      );

  Map<String, dynamic> toJson() => {
    "article_id": articleId,
    "link": link,
    "title": title,
    "description": description,
    "content": content,
    "keywords": keywords == null
        ? null
        : List<dynamic>.from(keywords!.map((x) => x)),
    "creator": creator == null
        ? null
        : List<dynamic>.from(creator!.map((x) => x)),
    "language": language,
    "country": country == null
        ? null
        : List<dynamic>.from(country!.map((x) => x)),
    "category": category == null
        ? null
        : List<dynamic>.from(category!.map((x) => x)),
    "pubDate": pubDate.toIso8601String(),
    "pubDateTZ": pubDateTz,
    "image_url": imageUrl,
    "video_url": videoUrl,
    "source_id": sourceId,
    "source_name": sourceName,
    "source_priority": sourcePriority,
    "source_url": sourceUrl,
    "source_icon": sourceIcon,
    "sentiment": sentiment,
    "sentiment_stats": sentimentStats,
    "ai_tag": aiTag,
    "ai_region": aiRegion,
    "ai_org": aiOrg,
    "ai_summary": aiSummary,
    "duplicate": duplicate,
  };
}
