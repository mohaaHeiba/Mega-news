// To parse this JSON data, do
//
//     final currentsNewsApiResponseModel = currentsNewsApiResponseModelFromJson(jsonString);

import 'dart:convert';

CurrentsNewsApiResponseModel currentsNewsApiResponseModelFromJson(String str) =>
    CurrentsNewsApiResponseModel.fromJson(json.decode(str));

String currentsNewsApiResponseModelToJson(CurrentsNewsApiResponseModel data) =>
    json.encode(data.toJson());

class CurrentsNewsApiResponseModel {
  final String status;
  final List<News> news;
  final int page;

  CurrentsNewsApiResponseModel({
    required this.status,
    required this.news,
    required this.page,
  });

  factory CurrentsNewsApiResponseModel.fromJson(Map<String, dynamic> json) =>
      CurrentsNewsApiResponseModel(
        status: json["status"],
        news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "news": List<dynamic>.from(news.map((x) => x.toJson())),
    "page": page,
  };
}

class News {
  final String id;
  final String title;
  final String description;
  final String url;
  final String author;
  final String image;
  final String language;
  final List<String> category;
  final String published;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.author,
    required this.image,
    required this.language,
    required this.category,
    required this.published,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    url: json["url"],
    author: json["author"],
    image: json["image"],
    language: json["language"],
    category: List<String>.from(json["category"].map((x) => x)),
    published: json["published"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "url": url,
    "author": author,
    "image": image,
    "language": language,
    "category": List<dynamic>.from(category.map((x) => x)),
    "published": published,
  };
}
