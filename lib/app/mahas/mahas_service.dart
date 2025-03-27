import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class MahasService {
  static Future<void> init() async {
    await initializeDateFormatting('id_ID');
    Intl.defaultLocale = 'id_ID';
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
