import 'package:get/get.dart';

import '../controllers/profile_change_language_controller.dart';

class ProfileChangeLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileChangeLanguageController>(
      () => ProfileChangeLanguageController(),
    );
  }
}
