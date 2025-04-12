import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
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
          actions: [
            Obx(
              () =>
                  controller.scannedDoc.isEmpty
                      ? SizedBox()
                      : GestureDetector(
                        onTap: controller.resetScan,
                        child: ImageComponent(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          localUrl: "assets/images/reset_scan.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
            ),
          ],
        ),
        floatingActionButton: Obx(
          () =>
              controller.scannedDoc.isEmpty
                  ? AnimatedBuilder(
                    animation: controller.animation,
                    builder: (context, _) {
                      return GestureDetector(
                        onTap: controller.scanDocument,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MahasColors.primary,
                            boxShadow: [
                              for (int i = 1; i <= 2; i++)
                                BoxShadow(
                                  color: MahasColors.primary.withValues(
                                    alpha:
                                        controller.animationController.value /
                                        3,
                                  ),
                                  spreadRadius:
                                      double.tryParse(
                                        (controller.animation.value * i)
                                            .toString(),
                                      ) ??
                                      25,
                                ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.document_scanner_outlined,
                                size: 40,
                                color: MahasColors.white,
                              ),
                              TextComponent(
                                value: "scan".tr,
                                fontWeight: FontWeight.w600,
                                fontColor: MahasColors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                  : SizedBox(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: Obx(
            () =>
                controller.scannedDoc.isEmpty
                    ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: Get.height * 0.2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageComponent(
                              localUrl: "assets/images/scan_here.png",
                            ),
                            TextComponent(
                              value: "tap_scan_subtitle".tr,
                              margin: EdgeInsets.only(top: 10),
                              fontSize: MahasFontSize.h6,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                    : ListView(
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      children: [
                        controller.scannedDoc.isNotEmpty
                            ? ReusableWidgets.scannedDocCarouselWidget(
                              imageList: controller.scannedDoc,
                            )
                            : SizedBox(),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          children: [
                            InputTextComponent(
                              controller: controller.receiptIdCon,
                              label: "Reicipt Id",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            InputTextComponent(
                              controller: controller.storeNameCon,
                              label: "Store Name",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            InputTextComponent(
                              controller: controller.purchaseDateCon,
                              label: "Purchase Date",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            InputTextComponent(
                              controller: controller.totalAmountCon,
                              label: "Total Amount",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            InputTextComponent(
                              controller: controller.currencyCon,
                              label: "Currency",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            InputTextComponent(
                              controller: controller.categoryCon,
                              label: "Category",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            InputTextComponent(
                              controller: controller.paymentMethodCon,
                              label: "Payment Method",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            InputTextComponent(
                              controller: controller.notesCon,
                              label: "Notes",
                              placeHolder: "name_hint".tr,
                              required: true,
                              marginBottom: 15,
                            ),
                            ButtonComponent(
                              onTap: () {},
                              // controller.saveOnTap,
                              text: "save".tr,
                              btnColor:
                                  controller.buttonActive.value
                                      ? MahasColors.primary
                                      : MahasColors.mediumgray,
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
