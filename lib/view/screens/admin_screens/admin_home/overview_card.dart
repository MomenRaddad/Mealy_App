import 'package:flutter/material.dart';
import 'package:meal_app/viewmodels/admin_dashboard/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/components/admin_components/state_card.dart';

class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel()..loadDashboardData(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey),
            SizedBox(height: context.hp(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: context.wp(112),
                  child: StatCard(
                    label: "Users",
                    count: vm.usersCount.toString(),
                    icon: Icons.person_outline,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(
                  width: context.wp(112),
                  child: StatCard(
                    label: "Admins",
                    count: vm.adminsCount.toString(),
                    icon: Icons.admin_panel_settings_outlined,
                    color: AppColors.accent1,
                  ),
                ),
                SizedBox(
                  width: context.wp(112),
                  child: StatCard(
                    label: "Meals",
                    count: vm.mealsCount.toString(),
                    icon: Icons.restaurant_menu,
                    color: AppColors.accent2,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
