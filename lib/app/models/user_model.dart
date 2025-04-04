import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> userModelToJson(UserModel data) => data.toJson();

class UserModel {
  String userid;
  String name;
  String email;
  String? profilepic;
  String? subscriptionplan;
  Timestamp? createdat;
  Timestamp? updatedat;

  UserModel({
    required this.userid,
    required this.name,
    required this.email,
    this.profilepic,
    this.subscriptionplan,
    this.createdat,
    this.updatedat,
  });

  static UserModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UserModel fromDynamic(dynamic dynamicData) {
    final model = UserModel(
      userid: dynamicData['userId'],
      name: dynamicData['name'],
      email: dynamicData['email'],
      profilepic: dynamicData['profilePic'],
      subscriptionplan: dynamicData['subscriptionPlan'],
      createdat: InputFormatter.dynamicToTimestamp(dynamicData['createdAt']),
      updatedat: InputFormatter.dynamicToTimestamp(dynamicData['updatedAt']),
    );
    return model;
  }

  Map<String, dynamic> toJson() => {
    'userId': userid,
    'name': name,
    'email': email,
    'profilePic': profilepic,
    'subscriptionPlan': subscriptionplan,
    'createdAt': createdat,
    'updatedAt': updatedat,
  };
}
