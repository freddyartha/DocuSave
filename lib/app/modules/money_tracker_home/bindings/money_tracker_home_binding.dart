import 'package:docusave/app/modules/money_tracker_budget/controllers/money_tracker_budget_controller.dart';
import 'package:docusave/app/modules/money_tracker_chart/controllers/money_tracker_chart_controller.dart';
import 'package:docusave/app/modules/money_tracker_list/controllers/money_tracker_list_controller.dart';
import 'package:get/get.dart';

import '../controllers/money_tracker_home_controller.dart';

class MoneyTrackerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoneyTrackerHomeController>(() => MoneyTrackerHomeController());
    Get.lazyPut<MoneyTrackerBudgetController>(
      () => MoneyTrackerBudgetController(),
    );
    Get.lazyPut<MoneyTrackerChartController>(
      () => MoneyTrackerChartController(),
    );
    Get.lazyPut<MoneyTrackerListController>(() => MoneyTrackerListController());
  }
}
