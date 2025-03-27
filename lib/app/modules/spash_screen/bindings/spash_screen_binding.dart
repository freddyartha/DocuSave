import 'package:get/get.dart';

import '../controllers/spash_screen_controller.dart';

class SpashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpashScreenController>(
      () => SpashScreenController(),
    );
  }
}
