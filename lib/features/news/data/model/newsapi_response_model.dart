// To parse this JSON data, do
//
//     final newsapiResponseModel = newsapiResponseModelFromJson(jsonString);

import 'dart:convert';

NewsapiResponseModel newsapiResponseModelFromJson(String str) =>
    NewsapiResponseModel.fromJson(json.decode(str));

String newsapiResponseModelToJson(NewsapiResponseModel data) =>
    json.encode(data.toJson());

class NewsapiResponseModel {
  final String status;
  final int totalResults;
  final List<NewsApiArticleModel> articles;

  NewsapiResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsapiResponseModel.fromJson(Map<String, dynamic> json) =>
      NewsapiResponseModel(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<NewsApiArticleModel>.from(
          json["articles"].map((x) => NewsApiArticleModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class NewsApiArticleModel {
  final NewsApiSourceModel source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  NewsApiArticleModel({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory NewsApiArticleModel.fromJson(Map<String, dynamic> json) =>
      NewsApiArticleModel(
        source: NewsApiSourceModel.fromJson(json["source"]),
        author: json["author"],
        title: json["title"] ?? "No Title",
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
    "source": source.toJson(),
    "author": author,
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt.toIso8601String(),
    "content": content,
  };
}

class NewsApiSourceModel {
  final String? id;
  final String name;

  NewsApiSourceModel({this.id, required this.name});

  factory NewsApiSourceModel.fromJson(Map<String, dynamic> json) =>
      NewsApiSourceModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
