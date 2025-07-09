import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarChartComponent extends StatelessWidget {
  final String label;
  final List<String> barTitle;
  final List<double> firstList;
  final List<double> secondList;

  const BarChartComponent({
    super.key,
    required this.label,
    required this.barTitle,
    required this.firstList,
    required this.secondList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextComponent(
          value: label,
          fontSize: MahasFontSize.h6,
          fontWeight: FontWeight.w600,
          margin: EdgeInsets.only(bottom: 15),
        ),
        firstList.isEmpty
            ? emptyWidget(context)
            : secondList.isEmpty
            ? emptyWidget(context)
            : AspectRatio(
              aspectRatio: 1,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: getMaxValue() + 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget:
                            (value, meta) => TextComponent(
                              value: barTitle[value.toInt()],
                              fontSize: MahasFontSize.small,
                            ),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(firstList.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: firstList[index],
                          color: MahasColors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(MahasRadius.small),
                          ),
                          width: 25,
                        ),
                        BarChartRodData(
                          toY: secondList[index],
                          color: MahasColors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(MahasRadius.small),
                          ),
                          width: 25,
                        ),
                      ],
                      barsSpace: 1,
                    );
                  }),
                ),
              ),
            ),
      ],
    );
  }

  Widget emptyWidget(context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        "assets/images/not_found.png",
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.7,
      ),
      TextComponent(
        value: "general_not_found".tr,
        fontSize: MahasFontSize.h6,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.center,
      ),
    ],
  );

  double getMaxValue() {
    final all = [...firstList, ...secondList];
    return all.isEmpty ? 0 : all.reduce((a, b) => a > b ? a : b);
  }
}
