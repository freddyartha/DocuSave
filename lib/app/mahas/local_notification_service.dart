import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  static void initialize() async {
    var androidInitialization = const AndroidInitializationSettings(
      "@drawable/logo",
    );
    var iOSInitialization = const DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitialization,
          iOS: iOSInitialization,
        );

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    final didNotificationLaunchApp =
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    if (didNotificationLaunchApp) {
      notificationAppLaunchDetails!.notificationResponse!;
    } else {
      _notificationsPlugin.initialize(initializationSettings);
    }

    getNotifikasi();
  }

  @pragma('vm:entry-point')
  static Future<void> showNotificationHandler(RemoteMessage message) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "com.freddydev.docusave",
        "DocuSave",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
        presentList: true,
        presentSound: true,
      ),
    );
    _notificationsPlugin.show(
      DateTime.now().microsecond,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.notification?.title,
    );
  }

  @pragma('vm:entry-point')
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static void getNotifikasi() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      await showNotificationHandler(initialMessage);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotificationHandler(message);
      if (message.notification != null) {
        // var data = message.data;
        // print(data.);
      }
    });

    FirebaseMessaging.onBackgroundMessage(showNotificationHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(showNotificationHandler);
  }
}
