import 'package:docusave/app/mahas/components/others/pie_chart_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
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
              : ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                ],
              ),
    );
  }
}
