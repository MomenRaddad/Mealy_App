import 'package:flutter/material.dart';
import 'package:meal_app/view/screens/admin_navigation_page.dart';
import 'package:meal_app/view/screens/user_navigation_page.dart';

class AccountSelector extends StatelessWidget {
  const AccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.admin_panel_settings),
              label: Text("Continue as Admin"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AdminNavigationPage()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text("Continue as User"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => UserNavigationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
