// To parse this JSON data, do
//
//     final gnewsResponseModel = gnewsResponseModelFromJson(jsonString);

import 'dart:convert';

GnewsResponseModel gnewsResponseModelFromJson(String str) =>
    GnewsResponseModel.fromJson(json.decode(str));

String gnewsResponseModelToJson(GnewsResponseModel data) =>
    json.encode(data.toJson());

class GnewsResponseModel {
  final Information information;
  final int totalArticles;
  final List<GNewsArticleModel> articles;

  GnewsResponseModel({
    required this.information,
    required this.totalArticles,
    required this.articles,
  });

  factory GnewsResponseModel.fromJson(Map<String, dynamic> json) =>
      GnewsResponseModel(
        information: Information.fromJson(json["information"]),
        totalArticles: json["totalArticles"],
        articles: List<GNewsArticleModel>.from(
          json["articles"].map((x) => GNewsArticleModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "information": information.toJson(),
    "totalArticles": totalArticles,
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class GNewsArticleModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String url;
  final String image;
  final DateTime publishedAt;
  final String lang;
  final GNewsSourceModel source;

  GNewsArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.lang,
    required this.source,
  });

  factory GNewsArticleModel.fromJson(Map<String, dynamic> json) =>
      GNewsArticleModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        content: json["content"],
        url: json["url"],
        image: json["image"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        lang: json["lang"],
        source: GNewsSourceModel.fromJson(json["source"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "content": content,
    "url": url,
    "image": image,
    "publishedAt": publishedAt.toIso8601String(),
    "lang": lang,
    "source": source.toJson(),
  };
}

class GNewsSourceModel {
  final String id;
  final String name;
  final String url;
  final String country;

  GNewsSourceModel({
    required this.id,
    required this.name,
    required this.url,
    required this.country,
  });

  factory GNewsSourceModel.fromJson(Map<String, dynamic> json) =>
      GNewsSourceModel(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "country": country,
  };
}

class Information {
  final RealTimeArticles realTimeArticles;

  Information({required this.realTimeArticles});

  factory Information.fromJson(Map<String, dynamic> json) => Information(
    realTimeArticles: RealTimeArticles.fromJson(json["realTimeArticles"]),
  );

  Map<String, dynamic> toJson() => {
    "realTimeArticles": realTimeArticles.toJson(),
  };
}

class RealTimeArticles {
  final String message;

  RealTimeArticles({required this.message});

  factory RealTimeArticles.fromJson(Map<String, dynamic> json) =>
      RealTimeArticles(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
