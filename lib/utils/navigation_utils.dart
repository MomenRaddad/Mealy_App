import 'package:flutter/material.dart';
import 'package:meal_app/core/routes.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

/// Unified Navigation Utility for Mealy App
/// Supports both traditional navigation and persistent_bottom_nav_bar screens.

class AppNavigator {
  // 🔹 For screens with bottom nav bar visible (within tab stack)
  static void pushWithNavBar(BuildContext context, Widget screen, {String? routeName}) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      screen: screen,
      settings: RouteSettings(name: routeName),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  // 🔹 For fullscreen screens (no bottom nav bar)
  static void pushWithoutNavBar(BuildContext context, Widget screen, {String? routeName}) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      screen: screen,
      settings: RouteSettings(name: routeName),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  // 🔹 Fade transition push (used outside nav bar or anywhere)
  static void pushWithFade(BuildContext context, Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ));
  }

  // 🔹 Fade transition replace
  static void replaceWithFade(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ));
  }

  // 🔹 Push named route with navbar (uses your generateRoute)
  static void pushNamedWithNavBar(BuildContext context, String routeName) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: Navigator(
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: routeName,
      ),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  // 🔹 Push named route without navbar (uses your generateRoute)
  static void pushNamedWithoutNavBar(BuildContext context, String routeName) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: Navigator(
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: routeName,
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }


  // 🔹 Basic go back
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
