import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../mahas/components/others/firebase_analytics_middleware.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile_account_setting/bindings/profile_account_setting_binding.dart';
import '../modules/profile_account_setting/views/profile_account_setting_view.dart';
import '../modules/profile_change_language/bindings/profile_change_language_binding.dart';
import '../modules/profile_change_language/views/profile_change_language_view.dart';
import '../modules/profile_list/bindings/profile_list_binding.dart';
import '../modules/profile_list/views/profile_list_view.dart';
import '../modules/profile_setup/bindings/profile_setup_binding.dart';
import '../modules/profile_setup/views/profile_setup_view.dart';
import '../modules/spash_screen/bindings/spash_screen_binding.dart';
import '../modules/spash_screen/views/spash_screen_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'HomePage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.SPASH_SCREEN,
      page: () => const SpashScreenView(),
      binding: SpashScreenBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'SpashScreenPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.PROFILE_LIST,
      page: () => const ProfileListView(),
      binding: ProfileListBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ProfileListPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.PROFILE_CHANGE_LANGUAGE,
      page: () => const ProfileChangeLanguageView(),
      binding: ProfileChangeLanguageBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ProfileChangeLanguagePage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.PROFILE_SETUP,
      page: () => const ProfileSetupView(),
      binding: ProfileSetupBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ProfileSetupPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'LoginPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.PROFILE_ACCOUNT_SETTING,
      page: () => const ProfileAccountSettingView(),
      binding: ProfileAccountSettingBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ProfileAccountSettingPage',
        ),
      ],
    ),
  ];
}
