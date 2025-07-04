import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'core/routes.dart';

//import 'view/screens/user_screens/details/meal_details_screen.dart';

import 'provider/theme_provider.dart';
import 'package:meal_app/view/screens/user_screens/meals/explore_viewmodel.dart';
import 'package:meal_app/view/screens/user_screens/details/meal_details_viewmodel.dart';
import 'package:meal_app/viewmodels/visited_meals_viewmodel.dart';
import 'package:meal_app/viewmodels/profile_viewmodel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ExploreViewModel()),
        ChangeNotifierProvider(create: (_) => MealDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => VisitedMealsViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Mealy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
