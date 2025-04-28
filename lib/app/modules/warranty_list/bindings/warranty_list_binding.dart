import 'package:get/get.dart';

import '../controllers/warranty_list_controller.dart';

class WarrantyListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarrantyListController>(
      () => WarrantyListController(),
    );
  }
}
