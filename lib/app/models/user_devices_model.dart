import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> userDevicesModelToJson(UserDevicesModel data) =>
    data.toJson();

class UserDevicesModel {
  String device;
  String deviceName;
  String brand;
  String os;
  bool isPhysicalDevice;
  Timestamp lastLogin;
  Timestamp createdat;

  UserDevicesModel({
    required this.device,
    required this.deviceName,
    required this.brand,
    required this.os,
    required this.isPhysicalDevice,
    required this.lastLogin,
    required this.createdat,
  });

  static UserDevicesModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UserDevicesModel fromDynamic(dynamic dynamicData) {
    final model = UserDevicesModel(
      device: dynamicData['device'],
      deviceName: dynamicData['deviceName'],
      brand: dynamicData['brand'],
      os: dynamicData['os'],
      isPhysicalDevice: dynamicData['isPhysicalDevice'],
      lastLogin: dynamicData['lastLogin'],
      createdat: dynamicData['createdat'],
    );
    return model;
  }

  Map<String, dynamic> toJson() => {
    'device': device,
    'deviceName': deviceName,
    'brand': brand,
    'os': os,
    'isPhysicalDevice': isPhysicalDevice,
    'lastLogin': lastLogin,
    'createdat': createdat,
  };
}
