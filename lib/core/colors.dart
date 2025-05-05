import 'package:flutter/material.dart';

class AppColors {
  //Backgrounds
  static const Color background = Color(0xFFF5F5F5); //Neutral Light

  //Brand
  static const Color primary = Color(0xFF4CAF50); //Primary Brand
  static const Color navbarBackground = Color(0xFF4CAF50);

  //Text
  static const Color textPrimary = Color(0xFF212121); //Neutral Dark
  static const Color textSecondary = Color(0xFF9E9E9E); //Neutral Medium

  //Accent Colors
  static const Color accent1 = Color(0xFFFF7043);
  //Secondary Button
  static const Color accent2 = Color(0xFFFFD54F); //Notifications

  // States
  static const Color success = Color(0xFF66BB6A); //Success
  static const Color error = Color(0xFFE53935);
}

//Y'all can use it inside the application without any troubles 
/*
Container(
  color: AppColors.background,
  child: Text(
    "",
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
*/