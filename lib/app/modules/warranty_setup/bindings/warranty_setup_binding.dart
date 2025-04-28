import 'package:get/get.dart';

import '../controllers/warranty_setup_controller.dart';

class WarrantySetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarrantySetupController>(
      () => WarrantySetupController(),
    );
  }
}
