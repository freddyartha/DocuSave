import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAccountSettingController extends GetxController {
  List<MenuItemModel> accountMenus = [
    MenuItemModel(
      title: "sign_out_title".tr,
      subtitle: "sign_out_subtitle".trParams(),
      icon: Icons.logout_rounded,
      onTab: () async {
        bool? result = await ReusableWidgets.confirmationBottomSheet(
          confirmColor: MahasColors.red,
          children: [TextComponent(value: "sign_out_confirm".tr)],
        );
        if (result == true) {
          await AuthController.instance.signOut();
        }
      },
    ),
    MenuItemModel(
      title: "delete_account_title".tr,
      subtitle: "delete_account_subtitle".tr,
      icon: Icons.delete_forever_outlined,
      onTab: () async {
        bool? result = await ReusableWidgets.confirmationBottomSheet(
          confirmColor: MahasColors.red,
          children: [TextComponent(value: "delete_account_confirm".tr)],
        );
        if (result == true) {
          await AuthController.instance.deleteAccount();
        }
      },
    ),
  ];
}
