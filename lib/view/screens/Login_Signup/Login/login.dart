import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meal_app/view/screens/Login_Signup/Signup/signup.dart';
import 'package:meal_app/view/screens/Login_Signup/forget_password/reset_password/reset_password_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pushReplacementNamed(context, '/userNav');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              color: Colors.green,
              height: 200,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2, color: Colors.green, endIndent: 250),
                  const SizedBox(height: 30),

                  const Text('Email'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'your@email.com',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Password'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: const UnderlineInputBorder(),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResetPasswordEmail()),
                      ),
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.green)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _login,
                      child: const Text("Login"),

                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Sign up",
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignUpScreen()),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    final controlPoint = Offset(size.width / 2, size.height);
    final endPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}