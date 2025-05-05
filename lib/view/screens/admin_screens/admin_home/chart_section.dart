import 'package:flutter/material.dart';

import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/bar_chart.dart';

class ChartSection extends StatelessWidget {
  const ChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daily App Visits ",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: context.hp(19)),
        DailyVisitsChart(visitsPerDay: [2, 5, 1, 3, 19, 7, 7]),
      ],
    );
  }
}
