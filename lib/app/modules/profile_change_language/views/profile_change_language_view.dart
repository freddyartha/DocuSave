import 'package:docusave/app/mahas/components/inputs/input_radio_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_change_language_controller.dart';

class ProfileChangeLanguageView
    extends GetView<ProfileChangeLanguageController> {
  const ProfileChangeLanguageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MahasColors.white,
      appBar: ReusableWidgets.generalAppBarWidget(
        title: "title_change_language".tr,
        backgroundColor: MahasColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InputRadioComponent(
            controller: controller.pilihBahasaCon,
            position: CheckboxPosition.right,
            spacing: 20,
          ),
        ),
      ),
    );
  }
}
