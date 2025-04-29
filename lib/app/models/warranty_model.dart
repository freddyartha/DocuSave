import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> warrantyModelToJson(WarrantyModel data) => data.toJson();

class WarrantyModel {
  String documentid;
  String itemname;
  String? serialnumber;
  Timestamp purchasedate;
  int warrantyperiodmonths;
  Timestamp warrantyexpirydate;
  String storename;
  String warrantyprovider;
  List<String> warrantyimage;
  String? notes;
  String? receiptid;
  bool remindersent;
  Timestamp createdat;
  Timestamp? updatedat;

  WarrantyModel({
    required this.documentid,
    required this.itemname,
    this.serialnumber,
    required this.purchasedate,
    required this.warrantyperiodmonths,
    required this.warrantyexpirydate,
    required this.storename,
    required this.warrantyprovider,
    required this.warrantyimage,
    this.notes,
    this.receiptid,
    required this.remindersent,
    required this.createdat,
    this.updatedat,
  });

  static WarrantyModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static WarrantyModel fromDynamic(dynamic dynamicData) {
    final model = WarrantyModel(
      documentid: dynamicData['documentId'],
      itemname: dynamicData['itemName'],
      serialnumber: dynamicData['serialNumber'],
      purchasedate:
          InputFormatter.dynamicToTimestamp(dynamicData['purchaseDate']) ??
          Timestamp.now(),
      warrantyperiodmonths:
          InputFormatter.dynamicToInt(dynamicData['warrantyPeriodMonths']) ?? 0,
      warrantyexpirydate:
          InputFormatter.dynamicToTimestamp(
            dynamicData['warrantyExpiryDate'],
          ) ??
          Timestamp.now(),
      storename: dynamicData['storeName'],
      warrantyprovider: dynamicData['warrantyProvider'],
      warrantyimage: [],
      notes: dynamicData['notes'],
      receiptid: dynamicData['receiptId'],
      remindersent:
          InputFormatter.dynamicToBool(dynamicData['reminderSent']) ?? false,
      createdat:
          InputFormatter.dynamicToTimestamp(dynamicData['createdAt']) ??
          Timestamp.now(),
      updatedat:
          InputFormatter.dynamicToTimestamp(dynamicData['updatedAt']) ??
          Timestamp.now(),
    );
    if (dynamicData['warrantyImage'] != null) {
      final detailT = dynamicData['warrantyImage'];
      for (var e in detailT) {
        model.warrantyimage.add(e);
      }
    }

    return model;
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentid,
    'itemName': itemname,
    'serialNumber': serialnumber,
    'purchaseDate': purchasedate,
    'warrantyPeriodMonths': warrantyperiodmonths,
    'warrantyExpiryDate': warrantyexpirydate,
    'storeName': storename,
    'warrantyProvider': warrantyprovider,
    'warrantyImage': warrantyimage,
    'notes': notes,
    'receiptId': receiptid,
    'reminderSent': remindersent,
    'createdAt': createdat,
    'updatedAt': updatedat,
  };
}
