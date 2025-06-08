import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/core/routes.dart';
import 'package:meal_app/models/user_session.dart';

class SettingsAdminScreen extends StatelessWidget {
  const SettingsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            UserSession.clear();
            await FirebaseAuth.instance.signOut();

            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil('/home', (route) => false);
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
