import 'package:get/get.dart';

import '../controllers/receipt_list_controller.dart';

class ReceiptListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptListController>(
      () => ReceiptListController(),
    );
  }
}
