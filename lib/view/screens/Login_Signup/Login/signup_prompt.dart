import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/view/screens/Login_Signup/Signup/signup.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: "Sign up",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
