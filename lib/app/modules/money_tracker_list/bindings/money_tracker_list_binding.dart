import 'package:get/get.dart';

import '../controllers/money_tracker_list_controller.dart';

class MoneyTrackerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoneyTrackerListController>(
      () => MoneyTrackerListController(),
    );
  }
}
