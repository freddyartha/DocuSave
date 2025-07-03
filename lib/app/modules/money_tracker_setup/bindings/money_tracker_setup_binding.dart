import 'package:get/get.dart';

import '../controllers/money_tracker_setup_controller.dart';

class MoneyTrackerSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoneyTrackerSetupController>(
      () => MoneyTrackerSetupController(),
    );
  }
}
