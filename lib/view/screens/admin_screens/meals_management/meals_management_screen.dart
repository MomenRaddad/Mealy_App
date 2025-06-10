import 'package:flutter/material.dart';

import 'package:meal_app/view/screens/admin_screens/meals_management/meals_management_body.dart';

class MealsManagementScreen extends StatelessWidget {
  const MealsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meals Management")),
      body: const MealsManagementBody(),
    );
  }
}
