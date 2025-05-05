import 'package:flutter/material.dart';
import 'package:meal_app/view/screens/admin_screens/settings/settings_screen.dart';
import 'package:meal_app/view/screens/switch_account.dart';
import '../view/screens/user_navigation_page.dart';
import '../view/screens/admin_navigation_page.dart';

class AppRoutes {
  // Route names
  static const String accountSelector = '/accountSelector';

  static const String userNav = '/userNav';
  static const String adminNav = '/adminNav';
  static const String settingsAdmin = '/settingsAdmin';

  // static const String mealDetails = '/meal-details';
  // static const String favorites = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case accountSelector:
        return MaterialPageRoute(builder: (_) => AccountSelector());
      case userNav:
        return MaterialPageRoute(builder: (_) => UserNavigationPage());
      case adminNav:
        return MaterialPageRoute(builder: (_) => AdminNavigationPage());
      case settingsAdmin:
        return MaterialPageRoute(builder: (_) => SettingsAdminScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  Scaffold(body: Center(child: Text('404 - Page Not Found'))),
        );
    }
  }
}
