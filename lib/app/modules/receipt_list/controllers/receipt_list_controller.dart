import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_checkbox_multiple_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/receipt_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiptListController extends GetxController {
  final searchCon = InputTextController();
  late ListComponentController<ReceiptModel> listCon;
  final defaultQuery = FirebaseRepository.getToReceiptCollection(
    auth.currentUser!.uid,
  ).orderBy('purchaseDate', descending: true);
  late Query filteredQuery;

  final InputDatetimeController fromDateCon = InputDatetimeController(
    maxDate: DateTime.now(),
  );
  final InputDatetimeController toDateCon = InputDatetimeController(
    maxDate: DateTime.now(),
  );

  final InputCheckboxMultipleController paymentMethodCon =
      InputCheckboxMultipleController(
        items: ReusableStatics.listCheckBoxPaymentMethod,
      );
  final InputCheckboxMultipleController categoryCon =
      InputCheckboxMultipleController(items: ReusableStatics.listKategori);

  @override
  void onInit() {
    listCon = ListComponentController(
      query: defaultQuery,
      fromDynamic: ReceiptModel.fromDynamic,
      searchOnType: (value) {
        return listCon.items.where((e) {
          final store = e.storename.toLowerCase();
          final category = e.category;
          final currency = e.currency.toLowerCase();
          final paymentmethod = e.paymentmethod;

          final notes = e.notes.toString().toLowerCase();
          final query = value.toLowerCase();

          return store.contains(query) ||
              category.toString() == query ||
              currency.contains(query) ||
              paymentmethod.toString() == query ||
              notes.contains(query);
        }).toList();
      },
      filterOnTap: () async {
        listCon.query = defaultQuery;
        toDateCon.value ??= DateTime.now();
        bool? result = await ReusableWidgets.confirmationBottomSheet(
          textCancel: "clear".tr,
          title: "Filter",
          children: [
            Row(
              children: [
                Expanded(
                  child: InputDatetimeComponent(
                    controller: fromDateCon,
                    label: "from_date".tr,
                    placeHolder: "from_date".tr,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InputDatetimeComponent(
                    controller: toDateCon,
                    label: "to_date".tr,
                    placeHolder: "to_date".tr,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: Get.height * 0.45,
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  InputCheckboxMultipleComponent(
                    controller: paymentMethodCon,
                    label: "payment_method".tr,
                    marginBottom: 20,
                  ),
                  InputCheckboxMultipleComponent(
                    controller: categoryCon,
                    label: "category".tr,
                  ),
                ],
              ),
            ),
          ],
        );

        if (result == true) {
          filteredQuery = defaultQuery;

          if (paymentMethodCon.value.isNotEmpty) {
            filteredQuery = filteredQuery.where(
              'paymentMethod',
              whereIn: paymentMethodCon.value,
            );
          }
          if (categoryCon.value.isNotEmpty) {
            filteredQuery = filteredQuery.where(
              'category',
              arrayContainsAny: categoryCon.value,
            );
          }
          if (fromDateCon.value != null && toDateCon.value != null) {
            filteredQuery = filteredQuery.where(
              'purchaseDate',
              isGreaterThanOrEqualTo: fromDateCon.value,
            );
            filteredQuery = filteredQuery.where(
              'purchaseDate',
              isLessThanOrEqualTo: toDateCon.value,
            );
          }
          listCon.query = filteredQuery;
          listCon.refresh();
        } else if (result == false) {
          clearFilterValues();
          listCon.query = defaultQuery;
          listCon.refresh();
        } else {
          clearFilterValues();
        }
      },
    );

    super.onInit();
  }

  void clearFilterValues() {
    paymentMethodCon.clearValue();
    categoryCon.clearValue();
    fromDateCon.value = null;
    toDateCon.value = null;
  }

  void goToReceiptSetup({String? id}) {
    Get.toNamed(
      Routes.RECEIPT_SETUP,
      parameters: id != null ? {"id": id} : null,
    )?.then((value) {
      if (value == true) {
        listCon.query = filteredQuery;
        listCon.refresh();
      }
    });
  }
}
