import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../mahas/components/others/firebase_analytics_middleware.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/money_tracker_budget/views/money_tracker_budget_view.dart';
import '../modules/money_tracker_chart/views/money_tracker_chart_view.dart';
import '../modules/money_tracker_home/bindings/money_tracker_home_binding.dart';
import '../modules/money_tracker_home/views/money_tracker_home_view.dart';
import '../modules/money_tracker_list/views/money_tracker_list_view.dart';
import '../modules/money_tracker_setup/bindings/money_tracker_setup_binding.dart';
import '../modules/money_tracker_setup/views/money_tracker_setup_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile_account_setting/bindings/profile_account_setting_binding.dart';
import '../modules/profile_account_setting/views/profile_account_setting_view.dart';
import '../modules/profile_change_language/bindings/profile_change_language_binding.dart';
import '../modules/profile_change_language/views/profile_change_language_view.dart';
import '../modules/profile_list/bindings/profile_list_binding.dart';
import '../modules/profile_list/views/profile_list_view.dart';
import '../modules/profile_setup/bindings/profile_setup_binding.dart';
import '../modules/profile_setup/views/profile_setup_view.dart';
import '../modules/profile_suggestion_setup/bindings/profile_suggestion_setup_binding.dart';
import '../modules/profile_suggestion_setup/views/profile_suggestion_setup_view.dart';
import '../modules/receipt_list/bindings/receipt_list_binding.dart';
import '../modules/receipt_list/views/receipt_list_view.dart';
import '../modules/receipt_setup/bindings/receipt_setup_binding.dart';
import '../modules/receipt_setup/views/receipt_setup_view.dart';
import '../modules/service_list/bindings/service_list_binding.dart';
import '../modules/service_list/views/service_list_view.dart';
import '../modules/service_setup/bindings/service_setup_binding.dart';
import '../modules/service_setup/views/service_setup_view.dart';
import '../modules/spash_screen/bindings/spash_screen_binding.dart';
import '../modules/spash_screen/views/spash_screen_view.dart';
import '../modules/warranty_list/bindings/warranty_list_binding.dart';
import '../modules/warranty_list/views/warranty_list_view.dart';
import '../modules/warranty_setup/bindings/warranty_setup_binding.dart';
import '../modules/warranty_setup/views/warranty_setup_view.dart';

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
    GetPage(
      name: _Paths.RECEIPT_LIST,
      page: () => const ReceiptListView(),
      binding: ReceiptListBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ReceiptListPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.RECEIPT_SETUP,
      page: () => const ReceiptSetupView(),
      binding: ReceiptSetupBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ReceiptSetupPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.WARRANTY_LIST,
      page: () => const WarrantyListView(),
      binding: WarrantyListBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'WarrantyListPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.WARRANTY_SETUP,
      page: () => const WarrantySetupView(),
      binding: WarrantySetupBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'WarrantySetupPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'OnboardingPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.PROFILE_SUGGESTION_SETUP,
      page: () => const ProfileSuggestionSetupView(),
      binding: ProfileSuggestionSetupBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ProfileSuggestionSetupPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.SERVICE_LIST,
      page: () => const ServiceListView(),
      binding: ServiceListBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ServiceListPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.SERVICE_SETUP,
      page: () => const ServiceSetupView(),
      binding: ServiceSetupBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'ServiceSetupPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.MONEY_TRACKER_HOME,
      page: () => const MoneyTrackerHomeView(),
      binding: MoneyTrackerHomeBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'MoneyTrackerHomePage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.MONEY_TRACKER_SETUP,
      page: () => const MoneyTrackerSetupView(),
      binding: MoneyTrackerSetupBinding(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'MoneyTrackerSetupPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.MONEY_TRACKER_LIST,
      page: () => const MoneyTrackerListView(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'MoneyTrackerListPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.MONEY_TRACKER_CHART,
      page: () => const MoneyTrackerChartView(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'MoneyTrackerChartPage',
        ),
      ],
    ),
    GetPage(
      name: _Paths.MONEY_TRACKER_BUDGET,
      page: () => const MoneyTrackerBudgetView(),
      middlewares: [
        FirebaseAnalyticsMiddleware(
          analytics: FirebaseAnalytics.instance,
          observer: FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          name: 'MoneyTrackerBudgetPage',
        ),
      ],
    ),
  ];
}
