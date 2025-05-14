import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/local_notification_service.dart';
import 'package:docusave/app/mahas/models/update_app_values_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

final remoteConfig = FirebaseRemoteConfig.instance;
final auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseMessaging messaging = FirebaseMessaging.instance;
final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
Reference firebaseStorage = FirebaseStorage.instance.ref();

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

    //init firebase
    await fetchFirebase();

    //init get storage
    await GetStorage.init();

    // init notification
    LocalNotificationService.initialize();

    // packageInfo
    MahasConfig.packageInfo = await PackageInfo.fromPlatform();

    //easyloading
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45
      ..radius = 15
      ..progressColor = MahasColors.primary
      ..backgroundColor = MahasColors.white
      ..indicatorColor = MahasColors.primary
      ..textColor = MahasColors.primary
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = true
      ..lineWidth = 5
      ..contentPadding = EdgeInsets.all(25)
      ..dismissOnTap = true;
  }

  //fetch remote config
  static Future<void> fetchFirebase() async {
    try {
      final Future<FirebaseApp> firebaseInitialization =
          Firebase.initializeApp();

      await firebaseInitialization.then((value) async {
        // Inisialisasi Firebase Crashlytics
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

        // Menangkap error global di aplikasi Flutter
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

        // firebase analytics
        FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

        // remote config
        await remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 1),
            minimumFetchInterval: Duration.zero,
          ),
        );
        await remoteConfig.fetchAndActivate();
        // get api from remote config
        String updateRemote = remoteConfig.getString("update_app_values");
        if (updateRemote.isNotEmpty) {
          MahasConfig.updateAppValues = UpdateappvaluesModel.fromJson(
            updateRemote,
          );
        }

        MahasConfig.demo = remoteConfig.getBool('demo');

        // auth controller
        AuthController.instance;
      });
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: "no_connection_subtitle".tr);
    }
  }
}
