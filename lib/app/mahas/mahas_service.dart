import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MahasService {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );

    //authController
    AuthController.instance;
  }
}
