import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class FirebaseAnalyticsMiddleware extends GetMiddleware {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final String name;

  FirebaseAnalyticsMiddleware({
    required this.analytics,
    required this.observer,
    required this.name,
  });

  @override
  GetPage<dynamic>? onPageCalled(GetPage<dynamic>? page) {
    if (page != null) {
      analytics.logScreenView(screenName: name);
    }
    return super.onPageCalled(page);
  }
}
