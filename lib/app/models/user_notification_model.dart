import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> userNotificationModelToJson(UserNotificationModel data) =>
    data.toJson();

class UserNotificationModel {
  String notificationToken;
  Timestamp createdat;

  UserNotificationModel({
    required this.notificationToken,
    required this.createdat,
  });

  static UserNotificationModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UserNotificationModel fromDynamic(dynamic dynamicData) {
    final model = UserNotificationModel(
      notificationToken: dynamicData['notificationToken'],
      createdat:
          InputFormatter.dynamicToTimestamp(dynamicData['createdAt']) ??
          Timestamp.now(),
    );
    return model;
  }

  Map<String, dynamic> toJson() => {
    'notificationToken': notificationToken,
    'createdAt': createdat,
  };
}
