import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_checkbox_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileListController extends GetxController {
  final InputCheckboxController shortcutToggle = InputCheckboxController();
  List<MenuItemModel> listProfiles = [];

  void goToProfileSetup() =>
      Get.toNamed(Routes.PROFILE_SETUP)?.then((value) => update());

  @override
  void onInit() {
    listProfiles.clear();
    listProfiles.addAll([
      MenuItemModel(
        title: "title_change_language",
        icon: Icons.language,
        onTab: () => Get.toNamed(Routes.PROFILE_CHANGE_LANGUAGE),
      ),
      MenuItemModel(
        title: "shortcut_money_tracker_short",
        icon: Icons.shortcut_rounded,
        onTab: showShortcutDialog,
      ),
      MenuItemModel(
        title: "privacy_policy",
        icon: Icons.insert_drive_file_outlined,
        onTab: ReusableStatics.launchPrivacyPolicy,
      ),
      MenuItemModel(
        title: "suggestion_tittle",
        icon: Icons.message_outlined,
        onTab: () => Get.toNamed(Routes.PROFILE_SUGGESTION_SETUP),
      ),
      MenuItemModel(
        title: "account_setting",
        icon: Icons.settings,
        onTab: () => Get.toNamed(Routes.PROFILE_ACCOUNT_SETTING),
      ),
    ]);

    shortcutToggle.checked =
        MahasConfig.userProfile!.moneytrackershortcut ?? false;
    shortcutToggle.onChanged = (value) async {
      await FirebaseRepository.addProfileMoneyTrackerShortcut(
        auth.currentUser!.uid,
        value,
      );
    };
    super.onInit();
  }

  void showShortcutDialog() async {
    ReusableWidgets.customBottomSheet(
      children: [
        InputCheckboxComponent(
          controller: shortcutToggle,
          label: "shortcut_money_tracker_short".tr,
          isSwitch: true,
        ),
      ],
    );
  }
}
