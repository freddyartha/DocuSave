import 'package:get/get.dart';

import '../controllers/money_tracker_home_controller.dart';

class MoneyTrackerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoneyTrackerHomeController>(
      () => MoneyTrackerHomeController(),
    );
  }
}
