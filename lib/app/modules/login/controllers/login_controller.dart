import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var authCon = AuthController.instance;
  void googleLoginOnPress() async {
    await authCon.signInWithGoogle();
  }

  void appleLoginOnPress() async {
    await authCon.signInWithApple();
  }
}
