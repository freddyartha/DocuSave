import 'package:docusave/app/mahas/components/others/pie_chart_component.dart';
import 'package:docusave/app/mahas/components/others/bar_chart_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/money_tracker_chart_controller.dart';

class MoneyTrackerChartView extends GetView<MoneyTrackerChartController> {
  const MoneyTrackerChartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.loadingData.value
              ? ReusableWidgets.formLoadingWidget()
              : controller.chartIsEmpty.value && !controller.loadingData.value
              ? ReusableWidgets.generalNotFoundWidget()
              : SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 20),
                  children: [
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            PieChartComponent(
                              label: "weekly_income_expense".tr,
                              model: controller.chartMingguanList,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  controller.listSummaryMingguan
                                      .map(
                                        (item) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextComponent(value: item.item),
                                            TextComponent(
                                              value: InputFormatter.toCurrency(
                                                item.value,
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            BarChartComponent(
                              label: "week_budget_spending".tr,
                              barTitle: List.generate(
                                controller.summaryModel!.totalweeks ?? 0,
                                (i) => "week_number".trParams({
                                  "value": "${i + 1}",
                                }),
                              ),
                              firstList:
                                  controller.summaryModel!.weeklybudget ?? [],
                              secondList:
                                  controller.summaryModel!.weeklyexpense,
                            ),
                            if (controller
                                    .summaryModel!
                                    .weeklybudget!
                                    .isNotEmpty &&
                                controller
                                    .summaryModel!
                                    .weeklyexpense
                                    .isNotEmpty) ...[
                              Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    MahasRadius.small,
                                  ),
                                  color: MahasColors.red.withValues(alpha: 0.2),
                                ),
                                child: TextComponent(
                                  height: 1.15,
                                  textAlign: TextAlign.center,
                                  fontColor: MahasColors.red,
                                  fontWeight: FontWeight.w500,
                                  value: "budget_spending_warning".tr,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            PieChartComponent(
                              label: "income_expense".tr,
                              model: controller.chartModelList,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  controller.listSummary
                                      .map(
                                        (item) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextComponent(value: item.item),
                                            TextComponent(
                                              value: InputFormatter.toCurrency(
                                                item.value,
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
