import 'package:get/get.dart';

import '../controllers/profile_suggestion_setup_controller.dart';

class ProfileSuggestionSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSuggestionSetupController>(
      () => ProfileSuggestionSetupController(),
    );
  }
}
