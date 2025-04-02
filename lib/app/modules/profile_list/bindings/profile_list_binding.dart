import 'package:get/get.dart';

import '../controllers/profile_list_controller.dart';

class ProfileListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileListController>(
      () => ProfileListController(),
    );
  }
}
