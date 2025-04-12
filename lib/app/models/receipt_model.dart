import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> userModelToJson(ReceiptModel data) => data.toJson();

class ReceiptModel {
  String? documentid;
  String? receiptid;
  String? storename;
  Timestamp? purchasedate;
  double? totalamount;
  String? currency;
  String? category;
  String? paymentmethod;
  String? receiptimage;
  String? notes;
  Timestamp? createdat;
  Timestamp? updatedat;

  static fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static fromDynamic(dynamic dynamicData) {
    final model = ReceiptModel();

    model.documentid = dynamicData['documentId'];
    model.receiptid = dynamicData['receiptId'];
    model.storename = dynamicData['storeName'];
    model.purchasedate = InputFormatter.dynamicToTimestamp(
      dynamicData['purchaseDate'],
    );
    model.totalamount = InputFormatter.dynamicToDouble(
      dynamicData['totalAmount'],
    );
    model.currency = dynamicData['currency'];
    model.category = dynamicData['category'];
    model.paymentmethod = dynamicData['paymentMethod'];
    model.receiptimage = dynamicData['receiptImage'];
    model.notes = dynamicData['notes'];
    model.createdat = InputFormatter.dynamicToTimestamp(
      dynamicData['createdAt'],
    );
    model.createdat = InputFormatter.dynamicToTimestamp(
      dynamicData['updatedAt'],
    );

    return model;
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentid,
    'receiptId': receiptid,
    'storeName': storename,
    'purchaseDate': purchasedate,
    'totalAmount': totalamount,
    'currency': currency,
    'category': category,
    'paymentMethod': paymentmethod,
    'receiptImage': receiptimage,
    'notes': notes,
    'createdAt': createdat,
    'updatedAt': updatedat,
  };
}
