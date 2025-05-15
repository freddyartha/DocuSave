import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> suggestionModelToJson(SuggestionModel data) =>
    data.toJson();

class SuggestionModel {
  String documentid;
  String userid;
  double rating;
  String? critique;
  String? suggestion;
  Timestamp createdat;

  SuggestionModel({
    required this.documentid,
    required this.userid,
    required this.rating,
    this.critique,
    this.suggestion,
    required this.createdat,
  });

  static SuggestionModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static SuggestionModel fromDynamic(dynamic dynamicData) {
    final model = SuggestionModel(
      documentid: dynamicData['documentId'],
      userid: dynamicData['userId'],
      rating: InputFormatter.dynamicToDouble(dynamicData['title']) ?? 0,
      critique: dynamicData['critique'],
      suggestion: dynamicData['suggestion'],
      createdat: dynamicData['createdAt'],
    );

    return model;
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentid,
    'userId': userid,
    'rating': rating,
    'critique': critique,
    'suggestion': suggestion,
    'createdAt': createdat,
  };
}
