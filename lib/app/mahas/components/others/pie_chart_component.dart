import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/models/chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartComponent extends StatefulWidget {
  final List<ChartModel> model;
  final String label;
  const PieChartComponent({
    super.key,
    required this.label,
    required this.model,
  });

  @override
  State<StatefulWidget> createState() => _PieChartComponentState();
}

class _PieChartComponentState extends State<PieChartComponent> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextComponent(
          value: widget.label,
          fontSize: MahasFontSize.h6,
          fontWeight: FontWeight.w600,
        ),
        AspectRatio(
          aspectRatio: 1.2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (pieTouchResponse != null &&
                        pieTouchResponse.touchedSection != null) {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    }
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections:
                  widget.model.asMap().entries.map((entry) {
                    int index = entry.key;
                    ChartModel item = entry.value;
                    final isTouched = index == touchedIndex;
                    final fontSize =
                        isTouched ? MahasFontSize.h6 : MahasFontSize.normal;
                    final radius = isTouched ? 110.0 : 100.0;
                    const shadows = [
                      Shadow(color: Colors.black, blurRadius: 2),
                    ];

                    return PieChartSectionData(
                      color: item.color,
                      value: item.value,
                      title: item.label,
                      radius: radius,
                      titleStyle: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: MahasColors.white,
                        shadows: shadows,
                      ),
                      badgePositionPercentageOffset: .98,
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
