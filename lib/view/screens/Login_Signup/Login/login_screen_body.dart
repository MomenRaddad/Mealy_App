import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:meal_app/utils/validation_utils.dart';
import 'package:meal_app/viewmodels/login_viewmodel.dart';
import 'package:meal_app/view/screens/Login_Signup/Login/login_form.dart';
import 'package:meal_app/view/screens/Login_Signup/Login/login_button.dart';
import 'package:meal_app/view/screens/Login_Signup/Login/login_header.dart';
import 'package:meal_app/view/screens/Login_Signup/Login/signup_prompt.dart';
import 'package:meal_app/view/screens/Login_Signup/Login/forgot_password_button.dart';
import 'package:meal_app/view/screens/Login_Signup/forget_password/reset_password/reset_password_email.dart';
import 'package:meal_app/view/components/top_wave_clipper.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final error = await LoginViewModel().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      rememberMe: _rememberMe,
    );

    if (!mounted) return;
    Navigator.of(context).pop();

    if (error != null) {
      _showErrorDialog(error);
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      UserSession.isPrivileged ? '/adminNav' : '/userNav',
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Login Failed'),
        content: Text(message, style: const TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                const SizedBox(height: 10),
                const LoginHeader(),
                const SizedBox(height: 30),
                LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  rememberMe: _rememberMe,
                  onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                  onRememberMeChanged: (val) => setState(() => _rememberMe = val ?? false),
                ),
                const ForgotPasswordButton(),
                const SizedBox(height: 20),
                LoginButton(onPressed: _login),
                const SizedBox(height: 20),
                const SignUpPrompt(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
