import 'package:get/get.dart';

import '../controllers/money_tracker_budget_controller.dart';

class MoneyTrackerBudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoneyTrackerBudgetController>(
      () => MoneyTrackerBudgetController(),
    );
  }
}
