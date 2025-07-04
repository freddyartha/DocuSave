import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_checkbox_multiple_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_dropdown_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_radio_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/money_tracker_setup_controller.dart';

class MoneyTrackerSetupView extends GetView<MoneyTrackerSetupController> {
  const MoneyTrackerSetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return ReusableWidgets.generalPopScopeWidget(
      showConfirmationCondition: controller.showConfirmationCondition,
      child: Scaffold(
        backgroundColor: MahasColors.white,
        extendBodyBehindAppBar: true,
        appBar: ReusableWidgets.generalAppBarWidget(
          title: "money_tracker".tr,
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
                            InputRadioComponent(
                              controller: controller.typeCon,
                              required: true,
                              label: "transaction_type".tr,
                              editable: controller.editable.value,
                              marginBottom: 15,
                            ),
                            InputCheckboxMultipleComponent(
                              controller: controller.categoryCon,
                              label: "category".tr,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.notesCon,
                              label: "notes".tr,
                              placeHolder: "money_notes_hint".tr,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),
                            InputTextComponent(
                              controller: controller.totalAmountCon,
                              label: "total_amount_money_tracker".tr,
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
                            InputDatetimeComponent(
                              controller: controller.dateTransactionCon,
                              label: "purchase_date".tr,
                              placeHolder: "purchase_date_hint".tr,
                              required: true,
                              marginBottom: 15,
                              editable: controller.editable.value,
                            ),

                            InputDropdownComponent(
                              controller: controller.paymentMethodCon,
                              label: "payment_method".tr,
                              placeHolder: "payment_method_hint".tr,
                              required: true,
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
