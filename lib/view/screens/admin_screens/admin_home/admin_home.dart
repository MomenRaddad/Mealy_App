import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/dashboard_card_data.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/chart_section.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/dashboard_section.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/header_section.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/overview_card.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/top_meals_section.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("size.width: ${size.width}");
    print("size.height: ${size.height}");
    print("context.wp(50): ${context.wp(12)}");

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: context.hp(14),
            right: context.wp(17),
            left: context.wp(17),
            bottom: context.hp(20),
          ),
          child: Column(
            children: [
              HeaderSection(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.wp(13)),
                child: Column(
                  children: [
                    SizedBox(height: context.wp(12)),
                    CardsSection(),

                    SizedBox(height: context.wp(20)),
                    ChartSection(),
                    SizedBox(height: context.wp(20)),
                    TopMealsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
