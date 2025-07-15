import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> userModelToJson(UserModel data) => data.toJson();

class UserModel {
  String userid;
  String name;
  String email;
  String selectedLanguage;
  String? profilepic;
  String? subscriptionplan;
  bool? moneytrackershortcut;
  Timestamp? createdat;
  Timestamp? updatedat;

  UserModel({
    required this.userid,
    required this.name,
    required this.email,
    required this.selectedLanguage,
    this.profilepic,
    this.subscriptionplan,
    this.moneytrackershortcut,
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
      selectedLanguage: dynamicData['selectedLanguage'],
      profilepic: dynamicData['profilePic'],
      subscriptionplan: dynamicData['subscriptionPlan'],
      moneytrackershortcut: dynamicData['MoneyTrackerShortcut'],
      createdat: InputFormatter.dynamicToTimestamp(dynamicData['createdAt']),
      updatedat: InputFormatter.dynamicToTimestamp(dynamicData['updatedAt']),
    );
    return model;
  }

  Map<String, dynamic> toJson() => {
    'userId': userid,
    'name': name,
    'email': email,
    'selectedLanguage': selectedLanguage,
    'profilePic': profilepic,
    'subscriptionPlan': subscriptionplan,
    'createdAt': createdat,
    'updatedAt': updatedat,
  };
}
