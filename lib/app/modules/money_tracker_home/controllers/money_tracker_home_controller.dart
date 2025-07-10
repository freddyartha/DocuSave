import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:docusave/app/modules/money_tracker_budget/controllers/money_tracker_budget_controller.dart';
import 'package:docusave/app/modules/money_tracker_budget/views/money_tracker_budget_view.dart';
import 'package:docusave/app/modules/money_tracker_chart/controllers/money_tracker_chart_controller.dart';
import 'package:docusave/app/modules/money_tracker_chart/views/money_tracker_chart_view.dart';
import 'package:docusave/app/modules/money_tracker_list/controllers/money_tracker_list_controller.dart';
import 'package:docusave/app/modules/money_tracker_list/views/money_tracker_list_view.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoneyTrackerHomeController extends GetxController
    with GetTickerProviderStateMixin {
  RxInt selectedIndex = 0.obs;
  final List<MenuItemModel> headerMenus = [];
  late TabController tabController;
  List<Widget> pages = [
    const MoneyTrackerBudgetView(),
    const MoneyTrackerChartView(),
    const MoneyTrackerListView(),
  ];

  final MoneyTrackerBudgetController budgetController =
      Get.isRegistered<MoneyTrackerBudgetController>()
          ? Get.find<MoneyTrackerBudgetController>()
          : Get.put(MoneyTrackerBudgetController());
  final MoneyTrackerListController listController =
      Get.isRegistered<MoneyTrackerListController>()
          ? Get.find<MoneyTrackerListController>()
          : Get.put(MoneyTrackerListController());
  final MoneyTrackerChartController chartController =
      Get.isRegistered<MoneyTrackerChartController>()
          ? Get.find<MoneyTrackerChartController>()
          : Get.put(MoneyTrackerChartController());

  @override
  void onInit() {
    headerMenus.addAll([
      MenuItemModel(title: "budget".tr, onTab: moveSelected),
      MenuItemModel(title: "chart".tr, onTab: moveSelected),
      MenuItemModel(title: "history".tr, onTab: moveSelected),
    ]);
    tabController = TabController(
      initialIndex: selectedIndex.value,
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
    super.onInit();
  }

  void moveSelected() {
    tabController.index = selectedIndex.value;
    if (selectedIndex.value == 1) {
      chartController.getThisMonthChart();
    }
  }

  void goToTransactionSetup({String? id}) {
    Get.toNamed(
      Routes.MONEY_TRACKER_SETUP,
      parameters: id != null ? {"id": id} : null,
    )?.then((value) async {
      if (value == true) {
        chartController.getThisMonthChart();
        listController.listCon.refresh();
      }
    });
  }
}
