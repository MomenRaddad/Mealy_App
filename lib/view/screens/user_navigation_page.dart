import 'package:flutter/material.dart';
import 'package:meal_app/core/nav_bar_theme.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../core/colors.dart';
import 'user_screens/home/home_screen.dart';
import 'user_screens/meals/explore_screen.dart';
import 'user_screens/profile/profile_screen.dart';
import 'user_screens/settings/settings_screen.dart';
import 'user_screens/tasks/add_task_screen.dart';


class UserNavigationPage extends StatefulWidget {
  const UserNavigationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserNavigationPageState createState() => _UserNavigationPageState();
}

class _UserNavigationPageState extends State<UserNavigationPage> {
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
        navBarHeight: MediaQuery.of(context).size.height * 0.07,
        padding: AppNavbarStyle.padding,
        context,
        controller: _controller,
        screens: [
          HomeScreen(),



          ExploreScreen(),
          TasksScreen(),

          ProfileScreen(),
          SettingsPreferencesScreen(),
        ],
        items: [
          PersistentBottomNavBarItem(
            icon: Icon(Icons.home, size: AppNavbarStyle.iconSize),
            title: "Home",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
            textStyle: AppNavbarStyle.textStyle,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.list, size: AppNavbarStyle.iconSize),
            title: "Tasks",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
            textStyle: AppNavbarStyle.textStyle,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.add, color: Colors.white),
            title: "",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
            textStyle: AppNavbarStyle.textStyle,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.person, size: AppNavbarStyle.iconSize),
            title: "Profile",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
            textStyle: AppNavbarStyle.textStyle,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.settings, size: AppNavbarStyle.iconSize),
            title: "Settings",
            activeColorPrimary: AppColors.primary,
            inactiveColorPrimary: AppColors.textSecondary,
            textStyle: AppNavbarStyle.textStyle,
          ),
        ],
        navBarStyle: NavBarStyle.style15,
        decoration: NavBarDecoration(
          // borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: AppColors.background,
        ),
    onItemSelected: (index) async {
    if (index == 2) {
    final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (result == 'refresh') {
    _controller.jumpToTab(0); // HomeScreen reload
    }
    } else {
    _controller.index = index;
    }
    },

      ),
    );
  }
}
