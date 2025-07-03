import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> moneyTrackerModelToJson(MoneyTrackerModel data) =>
    data.toJson();

class MoneyTrackerModel {
  String documentid;
  int type;
  List<int> category;
  double totalamount;
  String currency;
  Timestamp date;
  String? note;
  int paymentmethod;
  String? linkedreceiptid;
  Timestamp createdat;
  Timestamp? updatedat;

  MoneyTrackerModel({
    required this.documentid,
    required this.type,
    required this.category,
    required this.totalamount,
    required this.currency,
    required this.date,
    this.note,
    required this.paymentmethod,
    this.linkedreceiptid,
    required this.createdat,
    this.updatedat,
  });

  static MoneyTrackerModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static MoneyTrackerModel fromDynamic(dynamic dynamicData) {
    final model = MoneyTrackerModel(
      documentid: dynamicData['documentId'],
      type: InputFormatter.dynamicToInt(dynamicData['type']) ?? 0,
      category: [],
      totalamount:
          InputFormatter.dynamicToDouble(dynamicData['totalAmount']) ?? 0,
      currency: dynamicData['currency'],
      date:
          InputFormatter.dynamicToTimestamp(dynamicData['date']) ??
          Timestamp.now(),
      note: dynamicData['note'],
      paymentmethod: dynamicData['paymentMethod'],
      linkedreceiptid: dynamicData['linkedReceiptId'],
      createdat:
          InputFormatter.dynamicToTimestamp(dynamicData['createdAt']) ??
          Timestamp.now(),
      updatedat:
          InputFormatter.dynamicToTimestamp(dynamicData['updatedAt']) ??
          Timestamp.now(),
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

    return model;
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentid,
    'type': type,
    'category': category,
    'totalAmount': totalamount,
    'date': date,
    'note': note,
    'paymentMethod': paymentmethod,
    'linkedReceiptId': linkedreceiptid,
    'createdAt': createdat,
    'updatedAt': updatedat,
  };
}
