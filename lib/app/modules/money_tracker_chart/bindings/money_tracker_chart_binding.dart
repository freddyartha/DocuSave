import 'package:get/get.dart';

import '../controllers/money_tracker_chart_controller.dart';

class MoneyTrackerChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoneyTrackerChartController>(
      () => MoneyTrackerChartController(),
    );
  }
}
