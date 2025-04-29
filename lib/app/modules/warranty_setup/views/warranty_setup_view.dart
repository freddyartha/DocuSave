import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/warranty_setup_controller.dart';

class WarrantySetupView extends GetView<WarrantySetupController> {
  const WarrantySetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return ReusableWidgets.generalPopScopeWidget(
      showConfirmationCondition: controller.showConfirmationCondition,
      child: Scaffold(
        backgroundColor: MahasColors.white,
        extendBodyBehindAppBar: true,
        appBar: ReusableWidgets.generalAppBarWidget(
          title: "warranty".tr,
          backgroundColor: MahasColors.white,
          actions: [
            Obx(
              () =>
                  controller.scannedDoc.isNotEmpty && controller.editable.value
                      ? GestureDetector(
                        onTap: controller.resetScan,
                        child: ImageComponent(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          localUrl: "assets/images/reset_scan.png",
                          height: 30,
                          width: 30,
                        ),
                      )
                      : SizedBox(),
            ),
          ],
        ),
        floatingActionButton: Obx(
          () =>
              controller.scannedDoc.isEmpty && controller.id.isEmpty
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
                controller.id.value.isNotEmpty && controller.loadingData.value
                    ? ReusableWidgets.formLoadingWidget()
                    : controller.id.value.isEmpty &&
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
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      children: [
                        controller.scannedDoc.isNotEmpty
                            ? ReusableWidgets.scannedDocCarouselWidget(
                              imageList: controller.scannedDoc,
                              isNetworkImage:
                                  controller.id.value.isNotEmpty ? true : false,
                            )
                            : SizedBox(),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          children: [
                            InputTextComponent(
                              controller: controller.storeNameCon,
                              label: "store_name".tr,
                              placeHolder: "store_name_hint".tr,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.itemNameCon,
                              label: "item_name".tr,
                              placeHolder: "item_name_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.serialNumberCon,
                              label: "serial_number".tr,
                              placeHolder: "serial_number_hint".tr,
                              required: false,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputDatetimeComponent(
                              controller: controller.purchaseDateCon,
                              label: "purchase_date".tr,
                              placeHolder: "purchase_date_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.warrantyPeriodCon,
                              label: "warranty_period".tr,
                              placeHolder: "warranty_period_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputDatetimeComponent(
                              controller: controller.warrantyExpiryCon,
                              label: "warranty_expiry".tr,
                              placeHolder: "warranty_expiry_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.warrantyProviderCon,
                              label: "warranty_provider".tr,
                              placeHolder: "warranty_provider_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.receiptIdCon,
                              label: "receipt_id".tr,
                              placeHolder: "receipt_id_hint".tr,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.notesCon,
                              label: "notes".tr,
                              placeHolder: "notes_hint".tr,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            controller.editable.value
                                ? Column(
                                  spacing: 15,
                                  children: [
                                    ButtonComponent(
                                      onTap: controller.saveOnTap,
                                      text: "save".tr,
                                      btnColor:
                                          controller.buttonActive.value
                                              ? MahasColors.primary
                                              : MahasColors.mediumgray,
                                    ),
                                    controller.id.value.isNotEmpty
                                        ? ButtonComponent(
                                          onTap:
                                              () =>
                                                  controller.editable.value =
                                                      false,
                                          text: "cancel".tr,
                                          btnColor: MahasColors.darkBlue,
                                        )
                                        : SizedBox.shrink(),
                                  ],
                                )
                                : ReusableWidgets.generalEditDeleteButtonWidget(
                                  deleteOnTap: controller.deleteData,
                                  editOnTap:
                                      () => controller.editable.value = true,
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
