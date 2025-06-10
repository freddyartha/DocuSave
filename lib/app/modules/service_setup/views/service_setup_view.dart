import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/select_multiple_image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_radio_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/service_setup_controller.dart';

class ServiceSetupView extends GetView<ServiceSetupController> {
  const ServiceSetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return ReusableWidgets.generalPopScopeWidget(
      showConfirmationCondition: controller.showConfirmationCondition,
      child: Scaffold(
        backgroundColor: MahasColors.white,
        extendBodyBehindAppBar: true,
        appBar: ReusableWidgets.generalAppBarWidget(
          title: "service".tr,
          backgroundColor: MahasColors.white,
        ),
        body: SafeArea(
          child: Obx(
            () =>
                controller.id.value.isNotEmpty && controller.loadingData.value
                    ? ReusableWidgets.formLoadingWidget()
                    : ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      children: [
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          children: [
                            InputTextComponent(
                              controller: controller.productNameCon,
                              label: "product_name".tr,
                              placeHolder: "product_name_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputDatetimeComponent(
                              controller: controller.serviceDateCon,
                              label: "service_date".tr,
                              placeHolder: "service_date_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.storeNameCon,
                              label: "store_name".tr,
                              placeHolder: "store_name_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.problemDescCon,
                              label: "problem_description".tr,
                              placeHolder: "problem_description_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.serviceDescCon,
                              label: "service_description".tr,
                              placeHolder: "service_description_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.priceCon,
                              label: "price".tr,
                              placeHolder: "price_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.currencyCon,
                              label: "currency".tr,
                              placeHolder: "currency_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                              disableInputKeyboard: true,
                              suffixIcon:
                                  controller.editable.value
                                      ? Padding(
                                        padding: const EdgeInsets.only(
                                          right: 5,
                                        ),
                                        child: Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: 25,
                                        ),
                                      )
                                      : null,
                            ),
                            InputRadioComponent(
                              label: "service_status".tr,
                              controller: controller.statusCon,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputDatetimeComponent(
                              controller: controller.pickUpDateCon,
                              label: "pickup_date".tr,
                              placeHolder: "pickup_date_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.warrantyPeriodCon,
                              label: "warranty_period_day".tr,
                              placeHolder: "warranty_period_day_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputDatetimeComponent(
                              controller: controller.expiryDateCon,
                              label: "warranty_expiry".tr,
                              placeHolder: "warranty_expiry_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            SelectMultipleImagesComponent(
                              controller: controller.beforeServiceImagesCon,
                              editable: controller.editable.value,
                              label: "before_service_images".tr,
                              marginBottom: 15,
                            ),
                            SelectMultipleImagesComponent(
                              controller: controller.afterServiceImagesCon,
                              editable: controller.editable.value,
                              label: "after_service_images".tr,
                              marginBottom: 15,
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
