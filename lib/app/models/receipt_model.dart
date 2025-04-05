import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

class ReceiptModel {
  String? receiptid;
  String? storename;
  Timestamp? purchasedate;
  double? totalamount;
  String? currency;
  String? category;
  String? paymentmethod;
  List<ReceiptItemsModel>? items;
  String? receiptimage;
  String? notes;
  String? warrantyid;
  Timestamp? createdat;

  static fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static fromDynamic(dynamic dynamicData) {
    final model = ReceiptModel();

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
    if (dynamicData['items'] != null) {
      final detailT = dynamicData['items'] as List;
      model.items = [];
      for (var i = 0; i < detailT.length; i++) {
        model.items!.add(ReceiptItemsModel.fromDynamic(detailT[i]));
      }
    }
    model.receiptimage = dynamicData['receiptImage'];
    model.notes = dynamicData['notes'];
    model.warrantyid = dynamicData['warrantyId'];
    model.createdat = InputFormatter.dynamicToTimestamp(
      dynamicData['createdAt'],
    );

    return model;
  }
}

class ReceiptItemsModel {
  String? itemname;
  double? price;
  int? quantity;

  static fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static fromDynamic(dynamic dynamicData) {
    final model = ReceiptItemsModel();

    model.itemname = dynamicData['itemName'];
    model.price = InputFormatter.dynamicToDouble(dynamicData['price']);
    model.quantity = InputFormatter.dynamicToInt(dynamicData['quantity']);

    return model;
  }
}
