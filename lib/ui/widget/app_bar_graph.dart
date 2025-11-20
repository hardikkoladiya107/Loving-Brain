import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';

class AppBarGraph extends StatelessWidget {
  AppBarGraph({
    super.key,
    required this.height,
    this.interval = 2,
    required this.titles,
    required this.values,
    required this.showBest,
    this.showTitles = false,
    this.topPAdding = 50,
    this.hrTitlesWidget = defaultGetTitle,
    this.textColor,
  });
  final double height;
  Color? textColor;
  final double interval;
  final List<String> titles;
  final List<double> values;
  double topPAdding = 50;
  final bool showBest;
  final bool showTitles;
  Widget Function(double, TitleMeta) hrTitlesWidget;
  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFB3D9FF), // Sun
      const Color(0xFFC8B4E2), // Mon
      const Color(0xFFF4B965), // Tues
      const Color(0xFFFAE484), // Wed
      const Color(0xFFDADADA), // Thur
      const Color(0xFFC6D8FF), // Fri
      const Color(0xFFE1CCFF), // Sat
    ];

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final maxIndex = values.indexOf(maxValue);
    final chartHeight = height - maxValue; //
    // because you used .padding(top: 50)

    // ✅ Convert data value → pixel offset
    final barPixelHeight = (maxValue / 100) * chartHeight;
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          BarChart(
            BarChartData(
              maxY: maxValue,
              minY: 0,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: showTitles,
                drawHorizontalLine: showTitles,
              ),
              alignment: BarChartAlignment.spaceAround,

              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: showTitles
                    ? AxisTitles(
                        sideTitles: SideTitles(
                          interval: interval,
                          showTitles: showTitles,
                          getTitlesWidget: (value, meta) =>
                              hrTitlesWidget(value, meta),
                          reservedSize: 40,
                        ),
                        axisNameSize: 20,
                      )
                    : AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= titles.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          titles[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textColor ?? colors[index % 7],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(titles.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: values[index],
                      width: 36,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      color: colors[index % 7],
                    ),
                  ],
                );
              }),
              barTouchData: BarTouchData(enabled: true),
              extraLinesData: showTitles
                  ? ExtraLinesData(
                      verticalLines: [
                        VerticalLine(
                          x: 50,
                          // image: ,
                        ),
                      ],
                      extraLinesOnTop: false,
                      horizontalLines: [
                        ...List<HorizontalLine>.generate(
                          (maxValue / interval).round(),
                          (index) => HorizontalLine(
                            y: index * interval,
                            strokeWidth: 0.5,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ).padding(top: topPAdding),
          if (showBest && values.any((v) => v > 0))
            // 🏆 Add PNG for Best Day (WED)
            Positioned(
              top: 10,
              left: maxIndex * 50,
              // bottom: maxValue * 6.5,
              child: Column(
                children: [
                  Assets.icons.icBestDayEver.image(height: height * 0.15),
                  const SizedBox(height: 4),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
