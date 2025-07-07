import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_checkbox_multiple_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_dropdown_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_radio_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/money_tracker_model.dart';
import 'package:docusave/app/models/money_tracker_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MoneyTrackerSetupController extends GetxController {
  RxString id = "".obs;
  RxBool loadingData = false.obs;
  RxBool editable = true.obs;
  RxBool buttonActive = false.obs;

  late final MoneyTrackerModel? moneyTrackerModel;

  final InputRadioController typeCon = InputRadioController(
    items: ReusableStatics.listTypeMoneyTracker,
  );
  final InputCheckboxMultipleController categoryCon =
      InputCheckboxMultipleController(items: ReusableStatics.listKategori);
  final InputTextController notesCon = InputTextController(
    type: InputTextType.paragraf,
  );
  final InputTextController totalAmountCon = InputTextController(
    type: InputTextType.money,
  );
  final InputTextController currencyCon = InputTextController(
    type: InputTextType.text,
  );
  final InputDatetimeController dateTransactionCon = InputDatetimeController();
  final InputDropdownController paymentMethodCon = InputDropdownController(
    items: ReusableStatics.listPaymentMethod,
  );

  @override
  void onInit() async {
    dateTransactionCon.value = DateTime.now();
    currencyCon.value = "IDR";
    typeCon.value = 2;
    paymentMethodCon.value = 1;

    id.value = Get.parameters["id"] ?? "";
    if (id.value.isNotEmpty) {
      editable.value = false;
      loadingData.value = true;
      var r = await FirebaseRepository.getMoneyTrackerById(
        documentId: id.value,
        userUid: auth.currentUser!.uid,
      );
      loadingData.value = false;
      if (r != null) {
        moneyTrackerModel = r;
        typeCon.value = r.type;
        categoryCon.value = r.category;
        notesCon.value = r.note;
        totalAmountCon.value = r.totalamount;
        currencyCon.value = r.currency;
        dateTransactionCon.value = r.date;
        paymentMethodCon.value = r.paymentmethod;
      }
    } else {
      currencyOnTap();
    }

    ever(editable, (value) {
      if (value) {
        currencyOnTap();
      } else {
        currencyCon.onTap = () {};
      }
    });

    activateButton();
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
    typeCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    categoryCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    notesCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    totalAmountCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    currencyCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    dateTransactionCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    paymentMethodCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
  }

  bool showConfirmationCondition() {
    if (editable.value &&
        (categoryCon.value.isNotEmpty ||
            notesCon.value != null ||
            totalAmountCon.value != null)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveOnTap() async {
    if (buttonActive.value) {
      FocusScope.of(Get.context!).unfocus();
      bool validation = showConfirmationCondition();
      if (!validation) return;
      if (!typeCon.isValid) return;
      if (!categoryCon.isValid) return;
      if (!notesCon.isValid) return;
      if (!totalAmountCon.isValid) return;
      if (!currencyCon.isValid) return;
      if (!dateTransactionCon.isValid) return;
      if (!paymentMethodCon.isValid) return;
      buttonActive.value = false;
      if (auth.currentUser != null) {
        if (EasyLoading.isShow) EasyLoading.dismiss();
        await EasyLoading.show(status: "save_data".tr);
        MoneyTrackerModel model = MoneyTrackerModel(
          documentid: id.isNotEmpty ? id.value : ReusableStatics.idGenerator(),
          type: typeCon.value,
          category:
              categoryCon.value
                  .map((item) => InputFormatter.dynamicToInt(item) ?? 0)
                  .toList(),
          totalamount: totalAmountCon.value,
          currency: currencyCon.value,
          date: dateTransactionCon.value,
          paymentmethod: paymentMethodCon.value,
          note: notesCon.value,
          linkedreceiptid: null,
          createdat: Timestamp.now(),
          updatedat: id.isNotEmpty ? Timestamp.now() : null,
        );

        final monthKey = ReusableStatics.getMonthKey(
          dateTransactionCon.value.toDate(),
        );

        bool result =
            id.isNotEmpty
                ? await FirebaseRepository.updateMoneyTrackerToFirestore(
                  userUid: auth.currentUser!.uid,
                  monthKey: monthKey,
                  oldMoneyTrackerModel: moneyTrackerModel!,
                  updatedMoneyTrackerModel: model,
                )
                : await FirebaseRepository.addMoneyTrackerToFirestore(
                  userUid: auth.currentUser!.uid,
                  monthKey: monthKey,
                  moneyTrackerModel: model,
                  moneyTrackerSummaryModel: MoneyTrackerSummaryModel(
                    documentid: monthKey,
                    totalincome: typeCon.value == 1 ? totalAmountCon.value : 0,
                    totalexpense: typeCon.value == 2 ? totalAmountCon.value : 0,
                    createdat: Timestamp.now(),
                  ),
                );

        update();
        await EasyLoading.dismiss();
        if (result) {
          bool? result = await ReusableWidgets.notifBottomSheet(
            notifType: NotifType.success,
            subtitle: "success_save_transaction".tr,
          );
          if (result != null) Get.back(result: true);
        } else {
          buttonActive.value = true;
        }
      }
    }
  }

  void deleteData() async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    await EasyLoading.show(status: "delete_data".tr);

    bool result = await FirebaseRepository.subtractMoneyTrackerSummaryFirestore(
      userUid: auth.currentUser!.uid,
      moneyTrackerDocumentId: id.value,
    );
    if (result) {
      Get.back(result: true);
    }
    await EasyLoading.dismiss();
  }
}
