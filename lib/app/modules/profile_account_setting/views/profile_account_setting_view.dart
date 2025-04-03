import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/profile_account_setting_controller.dart';

class ProfileAccountSettingView
    extends GetView<ProfileAccountSettingController> {
  const ProfileAccountSettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MahasColors.white,
      appBar: ReusableWidgets.generalAppBarWidget(
        title: "account_setting".tr,
        backgroundColor: MahasColors.white,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.accountMenus.length,
        itemBuilder: (contex, index) {
          var item = controller.accountMenus[index];
          return ListTile(
            onTap: item.onTab,
            horizontalTitleGap: 10,
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(item.icon, color: MahasColors.darkgray),
            title: TextComponent(
              value: item.title,
              fontWeight: FontWeight.w600,
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: MahasColors.darkgray,
            ),
          );
        },
      ),
    );
  }
}
