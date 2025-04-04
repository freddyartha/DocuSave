import 'dart:convert';

Map<String, dynamic> articleModelToJson(ArticleModel data) => data.toJson();

class ArticleModel {
  String title;
  String subtitle;
  String imageUrl;
  String? link;

  ArticleModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.link,
  });

  static ArticleModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static ArticleModel fromDynamic(dynamic dynamicData) {
    final model = ArticleModel(
      title: dynamicData['title'],
      subtitle: dynamicData['subtitle'],
      imageUrl: dynamicData['imageUrl'],
      link: dynamicData['link'],
    );
    return model;
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'imageUrl': imageUrl,
    'link': link,
  };
}
