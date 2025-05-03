import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../core/colors.dart';
import 'user_screens/home/home_screen.dart';
import 'user_screens/tasks/tasks_screen.dart';
import 'user_screens/meals/meals_screen.dart';
import 'user_screens/profile/profile_screen.dart';
import 'user_screens/settings/settings_screen.dart';

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: [
        HomeScreen(),
        TasksScreen(),
        MealsScreen(),
        ProfileScreen(),
        SettingsScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: "Home",
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: AppColors.textSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.list),
          title: "Tasks",
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: AppColors.textSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.add, color: Colors.white),
          title: "Add",
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: AppColors.textSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: "Profile",
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
    );
  }
}
