import 'package:get/get.dart';

import '../controllers/profile_account_setting_controller.dart';

class ProfileAccountSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileAccountSettingController>(
      () => ProfileAccountSettingController(),
    );
  }
}
