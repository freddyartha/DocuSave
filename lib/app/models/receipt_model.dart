import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> receiptModelToJson(ReceiptModel data) => data.toJson();

class ReceiptModel {
  String documentid;
  String? receiptid;
  String storename;
  Timestamp? purchasedate;
  double totalamount;
  String currency;
  List<int> category;
  int paymentmethod;
  List<String> receiptimage;
  String? notes;
  Timestamp createdat;
  Timestamp? updatedat;

  ReceiptModel({
    required this.documentid,
    this.receiptid,
    required this.storename,
    this.purchasedate,
    required this.totalamount,
    required this.currency,
    required this.category,
    required this.paymentmethod,
    required this.receiptimage,
    this.notes,
    required this.createdat,
    this.updatedat,
  });

  static ReceiptModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static ReceiptModel fromDynamic(dynamic dynamicData) {
    final model = ReceiptModel(
      documentid: dynamicData['documentId'],
      receiptid: dynamicData['receiptId'],
      storename: dynamicData['storeName'],
      purchasedate: InputFormatter.dynamicToTimestamp(
        dynamicData['purchaseDate'],
      ),
      totalamount:
          InputFormatter.dynamicToDouble(dynamicData['totalAmount']) ?? 0,
      currency: dynamicData['currency'],
      category: [],
      paymentmethod:
          InputFormatter.dynamicToInt(dynamicData['paymentMethod']) ?? 0,
      receiptimage: [],
      notes: dynamicData['notes'],
      createdat: dynamicData['createdAt'],
      updatedat: dynamicData['updatedAt'],
    );
    if (dynamicData['category'] != null) {
      final detailT = dynamicData['category'];
      if (detailT is List) {
        for (var e in detailT) {
          model.category.add(InputFormatter.dynamicToInt(e) ?? 0);
        }
      } else {
        model.category.add(
          InputFormatter.dynamicToInt(dynamicData['category']) ?? 0,
        );
      }
    }
    if (dynamicData['receiptImage'] != null) {
      final detailT = dynamicData['receiptImage'];
      for (var e in detailT) {
        model.receiptimage.add(e);
      }
    }

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
