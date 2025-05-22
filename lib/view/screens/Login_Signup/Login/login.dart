import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/validation_utils.dart';

import 'package:meal_app/view/screens/Login_Signup/Signup/signup.dart';
import 'package:meal_app/view/screens/Login_Signup/forget_password/reset_password/reset_password_email.dart';
import 'package:meal_app/viewmodels/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(width: 20),
                Text("Logging in..."),
              ],
            ),
          ),
        );
      },
    );

    final _viewModel = LoginViewModel();
    final error = await _viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      rememberMe: _rememberMe,
    );

    Navigator.of(context).pop(); // dismiss loading dialog

    if (error != null) {
      showErrorDialog(context, error);
      return;
    }

    Navigator.pushReplacementNamed(context, '/userNav');
  }


  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Login Failed'),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textPrimary),
          ),
        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primary),
              ),            
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
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
              color: AppColors.primary,
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2, color: AppColors.primary, endIndent: 250),
                  const SizedBox(height: 30),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'your@email.com',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          validator: (value) {
                            if (!ValidationUtils.isValidEmail(value ?? '')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Password'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: const UnderlineInputBorder(),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          validator: (value) {
                            if (!ValidationUtils.isValidPassword(value ?? '')) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (val) => setState(() => _rememberMe = val!),
                              activeColor: AppColors.primary,
                            ),
                            const Text("Remember Me"),
                          ],
                        ),
                      ],
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
                      child: const Text("Forgot Password?", style: TextStyle(color: AppColors.primary)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
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
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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