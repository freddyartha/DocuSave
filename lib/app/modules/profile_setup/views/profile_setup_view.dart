import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_setup_controller.dart';

class ProfileSetupView extends GetView<ProfileSetupController> {
  const ProfileSetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return ReusableWidgets.generalPopScopeWidget(
      showConfirmationCondition: controller.showConfirmationCondition,
      child: Scaffold(
        backgroundColor: MahasColors.white,
        extendBodyBehindAppBar: true,
        appBar: ReusableWidgets.generalAppBarWidget(
          title: "profile".tr,
          backgroundColor: MahasColors.white,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            children: [
              GestureDetector(
                onTap: controller.pickImageOptions,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            MahasRadius.extraLarge * 2,
                          ),
                          color: MahasColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: MahasColors.black.withValues(alpha: 0.5),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.hardEdge,
                        child: GetBuilder(
                          builder: (ProfileSetupController controller) {
                            if (controller.fileImg != null) {
                              return ImageComponent(
                                imageFromFile: controller.fileImg!.path,
                                boxFit: BoxFit.cover,
                              );
                            } else if (MahasConfig.userProfile?.profilepic !=
                                null) {
                              return ImageComponent(
                                networkUrl: MahasConfig.userProfile?.profilepic,
                              );
                            } else {
                              return ImageComponent(
                                localUrl: "assets/images/user.png",
                              );
                            }
                          },
                        ),
                      ),
                      Obx(
                        () => TextComponent(
                          value: controller.editPictureLabel.value.tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    InputTextComponent(
                      controller: controller.namaCon,
                      label: "name".tr,
                      placeHolder: "name_hint".tr,
                      required: true,
                      marginBottom: 15,
                    ),
                    InputTextComponent(
                      controller: controller.emailCon,
                      label: "email".tr,
                      placeHolder: "email_hint".tr,
                      required: true,
                      marginBottom: 40,
                    ),
                    Obx(
                      () => ButtonComponent(
                        onTap: controller.saveOnTap,
                        text: "save".tr,
                        btnColor:
                            controller.buttonActive.value
                                ? MahasColors.primary
                                : MahasColors.mediumgray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
