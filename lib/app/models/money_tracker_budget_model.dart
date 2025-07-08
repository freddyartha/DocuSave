import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> moneyTrackerBudgetModelToJson(
  MoneyTrackerBudgetModel data,
) => data.toJson();

class MoneyTrackerBudgetModel {
  String documentid;
  double expensebudget;
  String currencycode;
  int totalweeks;
  List<double> weeklybudget;
  Timestamp? updatedat;

  MoneyTrackerBudgetModel({
    required this.documentid,
    required this.expensebudget,
    required this.currencycode,
    required this.totalweeks,
    required this.weeklybudget,
    this.updatedat,
  });

  Map<String, dynamic> toJson() => {
    'documentId': documentid,
    'expenseBudget': expensebudget,
    'currencyCode': currencycode,
    'totalWeeks': totalweeks,
    'weeklyBudget': weeklybudget,
    'updatedAt': updatedat,
  };
}
