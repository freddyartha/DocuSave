import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
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
    ),
    GetPage(
      name: _Paths.SPASH_SCREEN,
      page: () => const SpashScreenView(),
      binding: SpashScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_LIST,
      page: () => const ProfileListView(),
      binding: ProfileListBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_CHANGE_LANGUAGE,
      page: () => const ProfileChangeLanguageView(),
      binding: ProfileChangeLanguageBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SETUP,
      page: () => const ProfileSetupView(),
      binding: ProfileSetupBinding(),
    ),
  ];
}
