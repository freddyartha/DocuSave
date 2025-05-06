import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MahasColors.darkBlue,
              MahasColors.primary,
              MahasColors.primary,
              MahasColors.darkBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageComponent(
                      localUrl:
                          controller
                              .onBoardingList[controller.onBoardingIndex.value]
                              .image,
                      width: Get.width * 0.8,
                      height: Get.width * 0.8,
                      boxFit: BoxFit.fitWidth,
                    ),
                    TextComponent(
                      value:
                          controller
                              .onBoardingList[controller.onBoardingIndex.value]
                              .title,
                      fontColor: MahasColors.white,
                      fontSize: MahasFontSize.h3,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                    ),
                    TextComponent(
                      value:
                          controller
                              .onBoardingList[controller.onBoardingIndex.value]
                              .subtitle,
                      fontColor: MahasColors.white,
                      fontSize: MahasFontSize.h6,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                if (controller.onBoardingIndex.value <= 2) ...[
                  Positioned(
                    right: 0,
                    bottom: 30,
                    child: GestureDetector(
                      onTap: controller.nextOnTap,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            MahasRadius.regular,
                          ),
                          color: MahasColors.white,
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 35,
                          color: MahasColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.onBoardingIndex > 0,
                    child: Positioned(
                      left: 0,
                      bottom: 30,
                      child: GestureDetector(
                        onTap: controller.prevOnTap,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              MahasRadius.regular,
                            ),
                            color: MahasColors.white,
                          ),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            size: 35,
                            color: MahasColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (controller.onBoardingIndex.value > 2) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.bottomCenter,

                      child: ButtonComponent(
                        btnColor: MahasColors.white,
                        textColor: MahasColors.primary,
                        onTap: controller.requestPermission,
                        text: "Klik Disini",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
