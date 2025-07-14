import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_checkbox_multiple_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/others/list_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/money_tracker_model.dart';
import 'package:docusave/app/modules/money_tracker_chart/controllers/money_tracker_chart_controller.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MoneyTrackerListController extends GetxController {
  late ListComponentController<MoneyTrackerModel> listCon;
  final defaultQuery = FirebaseRepository.getToMoneyTrackerCollection(
    auth.currentUser!.uid,
  ).orderBy('date', descending: true);
  late Query filteredQuery;

  final InputDatetimeController fromDateCon = InputDatetimeController();
  final InputDatetimeController toDateCon = InputDatetimeController();
  final InputCheckboxMultipleController typeCon =
      InputCheckboxMultipleController(
        items: ReusableStatics.listCheckBoxTypeMoneyTracker,
      );
  final InputCheckboxMultipleController paymentMethodCon =
      InputCheckboxMultipleController(
        items: ReusableStatics.listCheckBoxPaymentMethod,
      );
  final InputCheckboxMultipleController categoryCon =
      InputCheckboxMultipleController(items: ReusableStatics.listKategori);

  final MoneyTrackerChartController chartController =
      Get.isRegistered<MoneyTrackerChartController>()
          ? Get.find<MoneyTrackerChartController>()
          : Get.put(MoneyTrackerChartController());

  @override
  void onInit() {
    filteredQuery = defaultQuery;
    listCon = ListComponentController(
      query: defaultQuery,
      fromDynamic: MoneyTrackerModel.fromDynamic,
      searchOnType: (value) {
        return listCon.items.where((e) {
          final category = e.category;
          final currency = e.currency.toLowerCase();
          final paymentmethod = e.paymentmethod;

          final notes = e.note.toString().toLowerCase();
          final query = value.toLowerCase();

          return category.toString() == query ||
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
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InputDatetimeComponent(
                    controller: toDateCon,
                    label: "to_date".tr,
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
                    controller: typeCon,
                    label: "transaction_type".tr,
                    marginBottom: 20,
                  ),
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
          if (typeCon.value.isNotEmpty) {
            filteredQuery = filteredQuery.where('type', whereIn: typeCon.value);
          }
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
              'date',
              isGreaterThanOrEqualTo: fromDateCon.value,
            );
            filteredQuery = filteredQuery.where(
              'date',
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
    typeCon.clearValue();
    paymentMethodCon.clearValue();
    fromDateCon.value = null;
    toDateCon.value = null;
  }

  void goToTransactionSetup({String? id}) {
    Get.toNamed(
      Routes.MONEY_TRACKER_SETUP,
      parameters: id != null ? {"id": id} : null,
    )?.then((value) async {
      if (value == true) {
        listCon.query = filteredQuery;
        listCon.refresh();
        chartController.getThisMonthChart();
      }
    });
  }
}
