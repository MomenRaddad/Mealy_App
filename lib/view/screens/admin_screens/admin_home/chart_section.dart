import 'package:flutter/material.dart';
import 'package:meal_app/viewmodels/admin_dashboard/AnalyticsViewModel.dart';
import 'package:provider/provider.dart';

import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/bar_chart.dart';

class ChartSection extends StatelessWidget {
  const ChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsViewModel()..loadWeeklyVisits(),
      child: const _ChartContent(),
    );
  }
}

class _ChartContent extends StatelessWidget {
  const _ChartContent();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AnalyticsViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daily App Visits",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: context.hp(19)),
        vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : DailyVisitsChart(visitsPerDay: vm.visitsPerDay),
      ],
    );
  }
}
