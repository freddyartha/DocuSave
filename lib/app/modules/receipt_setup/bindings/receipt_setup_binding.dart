import 'package:get/get.dart';

import '../controllers/receipt_setup_controller.dart';

class ReceiptSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptSetupController>(
      () => ReceiptSetupController(),
    );
  }
}
