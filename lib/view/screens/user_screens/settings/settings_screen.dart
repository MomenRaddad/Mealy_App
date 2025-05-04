import 'package:flutter/material.dart';
import 'package:meal_app/core/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              AppRoutes.accountSelector,
              (route) => false,
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
