import 'package:docusave/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance =
      Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController());

  @override
  void onInit() {
    _setInitialScreen();
    super.onInit();
  }

  void _setInitialScreen() {
    Future.delayed(Duration(seconds: 3), () => Get.offAllNamed(Routes.HOME));
  }
}
