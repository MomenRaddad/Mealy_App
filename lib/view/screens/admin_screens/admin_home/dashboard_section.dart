import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/components/admin_components/state_card.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey),
        SizedBox(height: context.hp(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            StatCard(
              color: AppColors.primary,
              icon: Icons.person_outline,
              label: 'Users ',
              count: '1,475',
            ),
            StatCard(
              color: AppColors.accent1,
              icon: Icons.admin_panel_settings_outlined,
              label: 'Admins',
              count: '50',
            ),
            StatCard(
              color: AppColors.accent2,
              icon: Icons.restaurant_menu,
              label: 'Meals ',
              count: '102,233',
            ),
          ],
        ),
      ],
    );
  }
}
