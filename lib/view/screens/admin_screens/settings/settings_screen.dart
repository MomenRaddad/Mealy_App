import 'package:flutter/material.dart';
import 'package:meal_app/view/screens/switch_account.dart';

class SettingsAdminScreen extends StatelessWidget {
  const SettingsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            
            Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (_) => const AccountSelector()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
