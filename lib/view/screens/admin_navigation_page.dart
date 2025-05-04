import 'package:flutter/material.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/admin_home.dart';
import 'package:meal_app/view/screens/admin_screens/meals_management/meals_screen.dart';
import 'package:meal_app/view/screens/admin_screens/settings/settings_screen.dart';
import 'package:meal_app/view/screens/admin_screens/user_management/user_mangement_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../core/colors.dart';

class AdminNavigationPage extends StatefulWidget {
  @override
  _AdminNavigationPageState createState() => _AdminNavigationPageState();
}

class _AdminNavigationPageState extends State<AdminNavigationPage> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: [
          AdminHomeScreen(),
          MealsManagementScreen(),
          UserManagementScreen(),
          UserManagementScreen(),
          SettingsAdminScreen(),
        ],
        items: [
          PersistentBottomNavBarItem(
            icon: Icon(Icons.home),
            title: "Admin",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.list),
            title: "Meals",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.add, color: Colors.white),
            title: "Users",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.person),
            title: "Users",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.settings),
            title: "Settings",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
          ),
        ],
        navBarStyle: NavBarStyle.style15,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: AppColors.background,
        ),
      ),
    );
  }
}
