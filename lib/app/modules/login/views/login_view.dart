import 'dart:io';

import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/texts/rich_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MahasColors.white,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ImageComponent(
                localUrl: "assets/images/welcome.png",
                height: Get.width * 0.7,
                width: Get.width,
                boxFit: BoxFit.fitHeight,
              ),
              TextComponent(
                value: "welcome_title".tr,
                fontWeight: FontWeight.w600,
                fontSize: MahasFontSize.h5,
                textAlign: TextAlign.center,
                margin: EdgeInsets.only(bottom: 5),
              ),
              TextComponent(
                textAlign: TextAlign.center,
                margin: EdgeInsets.only(bottom: 50),
                value: "welcome_subtitle".tr,
              ),
              Row(
                children: [
                  Expanded(
                    child: ButtonComponent(
                      onTap: controller.googleLoginOnPress,
                      text: "Google",
                      icon: "assets/images/google.png",
                      textColor: MahasColors.white,
                      btnColor: MahasColors.primary,
                      borderRadius: MahasRadius.large,
                      fontSize: MahasFontSize.normal,
                      fontWeight: FontWeight.w600,
                      isSvg: false,
                      iconSize: 30,
                    ),
                  ),
                  if (Platform.isIOS) ...[
                    SizedBox(width: 10),
                    Expanded(
                      child: ButtonComponent(
                        onTap: controller.appleLoginOnPress,
                        text: "Apple",
                        icon: "assets/images/apple.png",
                        textColor: MahasColors.white,
                        btnColor: MahasColors.black,
                        borderRadius: MahasRadius.large,
                        fontSize: MahasFontSize.normal,
                        fontWeight: FontWeight.w600,
                        isSvg: false,
                        iconSize: 30,
                      ),
                    ),
                  ],
                ],
              ),
              Obx(
                () => Visibility(
                  visible: controller.demo.isTrue,
                  child: Center(
                    child: TextButton(
                      onPressed: controller.demoOnPress,
                      child: const TextComponent(
                        value: "Demo",
                        fontColor: MahasColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: RichTextComponent(
                  textAlign: TextAlign.center,
                  teks: [
                    RichTextItem(
                      text: "saya_menyetujui".tr,
                      fontSize: MahasFontSize.small,
                    ),
                    RichTextItem(
                      text: "terms".tr,
                      onTap: ReusableStatics.launchPrivacyPolicy,
                      fontColor: MahasColors.primary,
                      underlineColor: MahasColors.primary,
                    ),
                    RichTextItem(text: " &\n", fontSize: MahasFontSize.small),
                    RichTextItem(
                      text: "privacy".tr,
                      onTap: ReusableStatics.launchPrivacyPolicy,
                      fontColor: MahasColors.primary,
                      underlineColor: MahasColors.primary,
                    ),
                    RichTextItem(
                      text: "app_name".tr,
                      fontSize: MahasFontSize.small,
                    ),
                  ],
                ),
              ),
              TextComponent(
                value: "v ${MahasConfig.packageInfo?.version}",
                margin: EdgeInsets.only(top: 10, bottom: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
