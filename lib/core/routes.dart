import 'package:flutter/material.dart';
import 'package:meal_app/view/screens/Login_Signup/Signup/signup.dart';
import 'package:meal_app/view/screens/admin_screens/settings/settings_screen.dart';
import 'package:meal_app/view/screens/switch_account.dart';
import '../view/screens/Login_Signup/Login/login.dart';
import '../view/screens/splash_screen/splash_screen.dart';
import '../view/screens/user_navigation_page.dart';
import '../view/screens/admin_navigation_page.dart';

import 'package:meal_app/view/screens/admin_screens/add_meal/add_meal.dart';
import 'package:meal_app/view/screens/user_screens/meals/explore_screen.dart';
import 'package:meal_app/view/screens/user_screens/details/meal_details_screen.dart'; 

class AppRoutes {
  // Route names
  static const String splashScreen='/splashScreen';
  static const String login='/login';
  static const String signup='/signup';
  static const String accountSelector = '/accountSelector';

  static const String userNav = '/userNav';
  static const String adminNav = '/adminNav';
  static const String settingsAdmin = '/settingsAdmin';
  static const String addMeal = '/addMeal';
  static const String mealDetails = '/mealDetails';
  static const String exploreMeals ='/exploreMeals';
  // static const String mealDetails = '/meal-details';
  // static const String favorites = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case accountSelector:
        return MaterialPageRoute(builder: (_) => AccountSelector());
      case userNav:
        return MaterialPageRoute(builder: (_) => UserNavigationPage());
      case adminNav:
        return MaterialPageRoute(builder: (_) => AdminNavigationPage());
      case settingsAdmin:
        return MaterialPageRoute(builder: (_) => SettingsAdminScreen());
      case addMeal:
        return MaterialPageRoute(builder: (_) => AddMealScreen());
      case exploreMeals:
      return MaterialPageRoute(builder:(_) => ExploreScreen() );
     case AppRoutes.mealDetails:
  final meal = settings.arguments as Map<String, dynamic>;
  return MaterialPageRoute(
    builder: (_) => MealDetailsScreen(
      title: meal['title'],
      image: meal['image'],
      duration: meal['duration'],
      difficulty: meal['difficulty'],
      ingredients: meal['ingredients'],
      steps: meal['steps'],
    ),
  );
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  Scaffold(body: Center(child: Text('404 - Page Not Found'))),
        );
    }
  }
}