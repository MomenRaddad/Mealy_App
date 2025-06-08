import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/view/components/top_wave_clipper.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper:  TopWaveClipper(),
          child: Container(
            color: AppColors.primary,
            height: 200,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Login',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 2, color: AppColors.primary, endIndent: 250),
        const SizedBox(height: 30),
      ],
    );
  }
}
