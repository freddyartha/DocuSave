import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileListController extends GetxController {
  List<MenuItemModel> listProfiles = [
    MenuItemModel(
      title: "title_change_language",
      icon: Icons.language,
      onTab: () => Get.toNamed(Routes.PROFILE_CHANGE_LANGUAGE),
    ),
    MenuItemModel(
      title: "privacy_policy",
      icon: Icons.insert_drive_file_outlined,
      onTab: ReusableStatics.launchPrivacyPolicy,
    ),
    MenuItemModel(
      title: "account_setting",
      icon: Icons.settings,
      onTab: () => Get.toNamed(Routes.PROFILE_ACCOUNT_SETTING),
    ),
  ];

  void goToProfileSetup() =>
      Get.toNamed(Routes.PROFILE_SETUP)?.then((value) => update());
}
