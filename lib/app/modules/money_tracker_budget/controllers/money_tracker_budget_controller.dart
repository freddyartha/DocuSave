import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/mahas/models/item_value_model.dart';
import 'package:docusave/app/models/money_tracker_budget_model.dart';
import 'package:docusave/app/models/money_tracker_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MoneyTrackerBudgetController extends GetxController {
  RxBool loadingData = false.obs;
  RxBool editable = true.obs;
  RxBool buttonActive = false.obs;
  RxBool showDetail = false.obs;
  RxBool isUpdate = false.obs;

  InputTextController budgetBulanCon = InputTextController(
    type: InputTextType.money,
  );
  final InputTextController currencyCon = InputTextController(
    type: InputTextType.text,
  );
  var weekControllers = <InputTextController>[].obs;
  var editedControllerIndexes = <ItemValueModel>[].obs;
  MoneyTrackerSummaryModel? summaryModel;

  @override
  void onInit() {
    currencyCon.value = "IDR";

    getInitialBudget();

    currencyOnTap();
    activateButton();

    ever(editable, (value) {
      if (value) {
        currencyOnTap();
      } else {
        currencyCon.onTap = () {};
      }
    });

    super.onInit();
  }

  void currencyOnTap() =>
      currencyCon.onTap =
          () => showCurrencyPicker(
            context: Get.context!,
            showFlag: true,
            showCurrencyName: true,
            showCurrencyCode: true,
            favorite: ["IDR", "USD", "SGD"],
            onSelect: (Currency currency) => currencyCon.value = currency.code,
            theme: ReusableStatics.currencyPickerTheme(),
          );

  void activateButton() {
    currencyCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive(true);
    };
    budgetBulanCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive(true);
    };
  }

  Future<void> getInitialBudget() async {
    loadingData(true);
    summaryModel = await FirebaseRepository.getMoneyTrackerSummaryByMonthKey(
      monthKey: ReusableStatics.getMonthKey(DateTime.now()),
      userUid: auth.currentUser!.uid,
    );
    if (summaryModel != null &&
        summaryModel!.expensebudget != null &&
        summaryModel!.expensebudget != 0) {
      showDetail(true);
      editable(false);
      budgetBulanCon.value = summaryModel!.expensebudget;
      currencyCon.value = summaryModel!.currencycode;
      final weeklyBudgetLength = summaryModel!.weeklybudget!.length;
      final weekCount = InputFormatter.dynamicToInt(weeklyBudgetLength) ?? 0;
      _generateTextComponents(weekCount);
      for (var i = 0; i < weeklyBudgetLength; i++) {
        for (
          int i = 0;
          i < weeklyBudgetLength && i < weekControllers.length;
          i++
        ) {
          weekControllers[i].value = summaryModel!.weeklybudget![i];
        }
      }

      for (var i = 0; i < weekControllers.length; i++) {
        weekControllers[i].onChanged = (value) {
          double v = InputFormatter.currencyToDouble(value.toString());

          // Cari apakah index sudah ada
          final existingIndex = editedControllerIndexes.indexWhere(
            (e) => e.item == i,
          );

          if (existingIndex != -1) {
            editedControllerIndexes[existingIndex].value = v;
          } else {
            editedControllerIndexes.add(ItemValueModel(item: i, value: v));
          }

          buttonActive(true);

          // Hitung total dari semua value yang diedit
          final total = editedControllerIndexes.fold<double>(
            0.0,
            (c, e) => c + e.value,
          );

          // // Ubah menjadi set agar pencarian lebih cepat
          // final editedItems =
          //     editedControllerIndexes.map((e) => e.item).toSet();

          for (var j = 0; j < weekControllers.length; j++) {
            final matched = editedControllerIndexes.firstWhereOrNull(
              (e) => e.item == j,
            );

            weekControllers[j].value =
                matched?.value ??
                (summaryModel!.expensebudget! - total) /
                    (weekCount - editedControllerIndexes.length);
          }
        };
      }

      budgetBulanCon.onChanged = (value) {
        buttonActive(true);
        double v = InputFormatter.currencyToDouble(value);
        for (var w in weekControllers) {
          w.value = v / weekCount;
        }
      };
    } else {
      showDetail(false);
    }
    loadingData(false);
  }

  Future<void> saveOnTap() async {
    if (buttonActive.value) {
      FocusScope.of(Get.context!).unfocus();
      if (!currencyCon.isValid) return;
      if (!budgetBulanCon.isValid) return;
      buttonActive(false);

      //perhitungan minggu
      final int weekcount = InputFormatter.getWeeksInCurrentMonth();
      if (!isUpdate.value) {
        _generateTextComponents(weekcount);
      }

      if (auth.currentUser != null) {
        if (EasyLoading.isShow) EasyLoading.dismiss();
        await EasyLoading.show(status: "save_data".tr);
        final monthKey = ReusableStatics.getMonthKey(DateTime.now());
        MoneyTrackerBudgetModel model = MoneyTrackerBudgetModel(
          documentid: monthKey,
          expensebudget: budgetBulanCon.value,
          currencycode: currencyCon.value,
          totalweeks: weekcount,
          weeklybudget:
              weekControllers
                  .map((v) => InputFormatter.dynamicToDouble(v.value) ?? 0)
                  .toList(),
          updatedat: Timestamp.now(),
        );

        var result = await FirebaseRepository.addBudgetMoneyTrackerToFirestore(
          userUid: auth.currentUser!.uid,
          moneyTrackerBudgetModel: model,
        );
        if (result != null) {
          showDetail(true);
          currencyCon.value = null;
          editable(false);
          isUpdate(false);
          summaryModel = result;
        } else {
          editable(true);
        }
        await EasyLoading.dismiss();
      }
    }
  }

  void _generateTextComponents(int weekCount) {
    weekControllers.clear();
    weekControllers.addAll(
      List.generate(
        weekCount,
        (_) => InputTextController(type: InputTextType.money)
          ..value =
              budgetBulanCon.value == null
                  ? null
                  : budgetBulanCon.value / weekCount,
      ),
    );
  }
}
