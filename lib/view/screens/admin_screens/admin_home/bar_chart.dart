import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';

class DailyVisitsChart extends StatelessWidget {
  final List<double> visitsPerDay;

  const DailyVisitsChart({super.key, required this.visitsPerDay});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var max = visitsPerDay.reduce((a, b) => a > b ? a : b);
    if (max < 5) {
      max = 5;
    }
    print(5);
    // double interval=  max
    return SizedBox(
      height: context.hp(200),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: max,
          barGroups: _buildData(size, max),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: max / 5,
                getTitlesWidget:
                    (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  return Text(
                    days[value.toInt()],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildData(final size, double max) {
    return List.generate(visitsPerDay.length, (index) {
      double maxValue = visitsPerDay.reduce((a, b) => a > b ? a : b);
      maxValue = maxValue % 2 == 0 ? maxValue : maxValue + 1;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: visitsPerDay[index],
            width: size.width * 0.063,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: max,
              color: Colors.green.shade100,
            ),
          ),
        ],
      );
    });
  }
}
