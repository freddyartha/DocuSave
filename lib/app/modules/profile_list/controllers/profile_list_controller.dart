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
    ),
    MenuItemModel(title: "account_setting", icon: Icons.settings),
  ];

  void goToProfileSetup() => Get.toNamed(Routes.PROFILE_SETUP);
}
