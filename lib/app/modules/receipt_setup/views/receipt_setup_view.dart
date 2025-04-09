import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/receipt_setup_controller.dart';

class ReceiptSetupView extends GetView<ReceiptSetupController> {
  const ReceiptSetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return ReusableWidgets.generalPopScopeWidget(
      showConfirmationCondition: () => true,
      // controller.showConfirmationCondition,
      child: Scaffold(
        backgroundColor: MahasColors.white,
        extendBodyBehindAppBar: true,
        appBar: ReusableWidgets.generalAppBarWidget(
          title: "receipt".tr,
          backgroundColor: MahasColors.white,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            physics: ClampingScrollPhysics(),
            children: [
              ButtonComponent(onTap: controller.scanDocument, text: "Scan"),
              GetBuilder(
                builder:
                    (ReceiptSetupController controller) =>
                        controller.scannedDoc.isNotEmpty
                            ? ImageComponent(
                              imageFromFile: controller.scannedDoc.first,
                              boxFit: BoxFit.cover,
                            )
                            : SizedBox(),
              ),
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
                  onTap: () {},
                  // controller.saveOnTap,
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
      ),
    );
  }
}
