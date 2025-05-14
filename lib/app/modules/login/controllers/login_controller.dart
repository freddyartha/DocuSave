import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var authCon = AuthController.instance;
  RxBool demo = false.obs;

  @override
  void onInit() async {
    demo.value = MahasConfig.demo;
    super.onInit();
  }

  void googleLoginOnPress() async {
    await authCon.signInWithGoogle();
  }

  void appleLoginOnPress() async {
    await authCon.signInWithApple();
  }

  void demoOnPress() async {
    await authCon.singInWithPassword('demo@demo.com', '123456');
  }
}
