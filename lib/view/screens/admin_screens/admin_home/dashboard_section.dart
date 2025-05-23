import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/dashboard_card_data.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/components/admin_components/state_card.dart';

class DashboardSection extends StatelessWidget {
  final List<DashboardCardData> cards;

  const DashboardSection({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey),
        SizedBox(height: context.hp(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              cards
                  .map(
                    (data) => SizedBox(
                      width: context.wp(112),
                      child: StatCard(
                        color: data.color,
                        icon: data.icon,
                        label: data.label,
                        count: data.count,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
