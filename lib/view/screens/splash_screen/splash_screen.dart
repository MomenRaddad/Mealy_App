import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:meal_app/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meal_app/view/screens/Login_Signup/Login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('rememberMe') ?? false;
      final user = FirebaseAuth.instance.currentUser;

      final isConnected =  await NetworkUtils.checkInternetAndShowDialog(context);
      
      if (!isConnected) {
        // If no internet, show dialog and return
        _checkLoginStatus(); // recursive retry
        return;
      }

      if (rememberMe && user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = doc.data();

        if (data != null) {
          UserSession.fromMap(data);

          debugPrint(UserSession.toStringDetails());

          if (UserSession.isPrivileged) {
            Navigator.pushReplacementNamed(context, '/adminNav');
          } else {
            Navigator.pushReplacementNamed(context, '/userNav');
          }
          return;
        }
      }

      // Fallback to login screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      // Session failed — go to login and show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auto-login failed: ${e.toString()}")),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: _BouncingMealyText(),
      ),
    );
  }
}

  class _BouncingMealyText extends StatefulWidget {
    const _BouncingMealyText({Key? key}) : super(key: key);

    @override
    State<_BouncingMealyText> createState() => _BouncingMealyTextState();
  }

  class _BouncingMealyTextState extends State<_BouncingMealyText> with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _scaleAnimation;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      )..repeat(reverse: true);

      _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: const Text(
          'Mealy',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.4,
          ),
        ),
      );
    }
  }

