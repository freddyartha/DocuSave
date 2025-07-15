import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/money_tracker_budget_controller.dart';

class MoneyTrackerBudgetView extends GetView<MoneyTrackerBudgetController> {
  const MoneyTrackerBudgetView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.loadingData.value
              ? ReusableWidgets.formLoadingWidget()
              : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(
                      children:
                          controller.showDetail.value
                              ? [
                                TextComponent(
                                  value: "this_month_expense".tr,
                                  fontSize: MahasFontSize.h6,
                                ),
                                TextComponent(
                                  value:
                                      "${controller.summaryModel!.currencycode} ${InputFormatter.toCurrency(controller.summaryModel!.expensebudget)}",
                                  fontSize: MahasFontSize.h4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ]
                              : [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  spacing: 10,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: InputTextComponent(
                                        controller: controller.currencyCon,
                                        label: "currency".tr,
                                        placeHolder: "currency_hint".tr,
                                        required: true,
                                        editable: controller.editable.value,
                                        disableInputKeyboard: true,
                                        suffixIcon:
                                            controller.editable.value
                                                ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 5,
                                                      ),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_drop_down_outlined,
                                                    size: 25,
                                                  ),
                                                )
                                                : null,
                                      ),
                                    ),
                                    Expanded(
                                      child: InputTextComponent(
                                        required: true,
                                        controller: controller.budgetBulanCon,
                                        label: "this_month_expense".tr,
                                        placeHolder:
                                            "this_month_expense_subtitle".tr,
                                      ),
                                    ),
                                  ],
                                ),
                                ButtonComponent(
                                  onTap: controller.saveOnTap,
                                  text: "save".tr,
                                  btnColor:
                                      controller.buttonActive.value
                                          ? MahasColors.primary
                                          : MahasColors.mediumgray,
                                ),
                              ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      decoration: BoxDecoration(
                        color: MahasColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(MahasRadius.large),
                          topRight: Radius.circular(MahasRadius.large),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: MahasColors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(0, -1),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          children: [
                            ...List.generate(
                              controller.weekControllers.length,
                              (index) => InputTextComponent(
                                label: "week_number".trParams({
                                  "value": "${index + 1}",
                                }),
                                controller: controller.weekControllers[index],
                                editable: controller.editable.value,
                                marginBottom: 15,
                              ),
                            ),
                            Visibility(
                              visible: controller.showDetail.value,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: ButtonComponent(
                                  onTap: () {
                                    controller.editable(true);
                                    controller.showDetail(false);
                                    controller.isUpdate(true);
                                  },
                                  text: "edit".tr,
                                  btnColor: MahasColors.primary,
                                  borderColor: MahasColors.white,
                                  icon: "assets/images/edit.png",
                                  isSvg: false,
                                  iconSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
