import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/view/components/admin_components/meal_card.dart';
import 'package:meal_app/view/components/admin_components/state_card.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/bar_chart.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/meals_test_data.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print('Width: ${size.width}');
    // print('Height: ${size.height}');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.015,

            right: size.width * 0.04,
            left: size.width * 0.04,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.red,

                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://as1.ftcdn.net/v2/jpg/06/99/46/60/1000_F_699466075_DaPTBNlNQTOwwjkOiFEoOvzDV0ByXR9E.jpg',
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        placeholder:
                            (context, url) => CircularProgressIndicator(),
                        errorWidget:
                            (context, url, error) => Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.048),

                  Text(
                    "Mo'men Raddad",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    // iconSize: 45,
                    iconSize: size.width * 0.11,
                    color: AppColors.textPrimary,
                    icon: Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed('/settingsAdmin');
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.012),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: size.height * 0.022),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
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
                    SizedBox(height: size.height * 0.02),

                    Text(
                      "Daily App Visits ",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    DailyVisitsChart(visitsPerDay: [2, 5, 1, 3, 19, 7, 7]),
                    SizedBox(height: size.height * 0.02),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return MealCard(
                          title: meal.title,
                          imageUrl: meal.imageUrl,
                          type: meal.type,
                          timeAndCal: meal.timeAndCal,
                          likes: meal.likes,
                          chefs: meal.chefs,
                          rating: meal.rating,
                        );
                      },
                    ),
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
