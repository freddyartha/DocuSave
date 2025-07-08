import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> moneyTrackerSummaryModelToJson(
  MoneyTrackerSummaryModel data,
) => data.toJson();

class MoneyTrackerSummaryModel {
  String documentid;
  double totalincome;
  double totalexpense;
  List<double> weeklyexpense;
  double? expensebudget;
  String? currencycode;
  int? totalweeks;
  List<double>? weeklybudget;
  Timestamp createdat;
  Timestamp? updatedat;

  MoneyTrackerSummaryModel({
    required this.documentid,
    required this.totalincome,
    required this.totalexpense,
    required this.weeklyexpense,
    this.expensebudget,
    this.currencycode,
    this.totalweeks,
    this.weeklybudget,
    required this.createdat,
    this.updatedat,
  });

  static MoneyTrackerSummaryModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static MoneyTrackerSummaryModel fromDynamic(dynamic dynamicData) {
    final model = MoneyTrackerSummaryModel(
      documentid: dynamicData['documentId'],
      totalincome:
          InputFormatter.dynamicToDouble(dynamicData['totalIncome']) ?? 0,
      totalexpense:
          InputFormatter.dynamicToDouble(dynamicData['totalExpense']) ?? 0,
      weeklyexpense: [],
      currencycode: dynamicData['currencyCode'],
      expensebudget:
          InputFormatter.dynamicToDouble(dynamicData['expenseBudget']) ?? 0,
      totalweeks: InputFormatter.dynamicToInt(dynamicData['totalWeeks']) ?? 0,
      weeklybudget: [],
      createdat:
          InputFormatter.dynamicToTimestamp(dynamicData['createdAt']) ??
          Timestamp.now(),
      updatedat:
          InputFormatter.dynamicToTimestamp(dynamicData['updatedAt']) ??
          Timestamp.now(),
    );

    if (dynamicData['weeklyExpense'] != null) {
      final detailT = dynamicData['weeklyExpense'];
      if (detailT is List) {
        for (var e in detailT) {
          model.weeklyexpense.add(InputFormatter.dynamicToDouble(e) ?? 0);
        }
      } else {
        model.weeklyexpense.add(
          InputFormatter.dynamicToDouble(dynamicData['weeklyExpense']) ?? 0,
        );
      }
    }

    if (dynamicData['weeklyBudget'] != null) {
      final detailT = dynamicData['weeklyBudget'];
      if (detailT is List) {
        for (var e in detailT) {
          model.weeklybudget!.add(InputFormatter.dynamicToDouble(e) ?? 0);
        }
      } else {
        model.weeklybudget!.add(
          InputFormatter.dynamicToDouble(dynamicData['weeklyBudget']) ?? 0,
        );
      }
    }

    return model;
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentid,
    'totalIncome': totalincome,
    'totalExpense': totalexpense,
    'weeklyExpense': weeklyexpense,
    'createdAt': createdat,
    'updatedAt': updatedat,
  };
}
