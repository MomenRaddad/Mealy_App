import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordEmail extends StatefulWidget {
  const ResetPasswordEmail({super.key});

  @override
  State<ResetPasswordEmail> createState() => _ResetPasswordEmailState();
}

class _ResetPasswordEmailState extends State<ResetPasswordEmail> {
  final TextEditingController _emailController = TextEditingController();
  bool _isCooldown = false;
  DateTime? _lastSentTime;
  Timer? _cooldownTimer;
  Duration _remainingCooldown = Duration.zero;

  @override
  void initState() {
    super.initState();
    _checkCooldownOnStart();
  }

  Future<void> _checkCooldownOnStart() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetMillis = prefs.getInt('lastResetTime');

    if (lastResetMillis != null) {
      final lastResetTime = DateTime.fromMillisecondsSinceEpoch(lastResetMillis);
      final now = DateTime.now();
      final elapsed = now.difference(lastResetTime);

      if (elapsed < const Duration(minutes: 2)) {
        _remainingCooldown = const Duration(minutes: 2) - elapsed;
        _startCooldown(); // start live countdown
      }
    }
  }

  void _showError(String message) {
    showDialog(      
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          "Error",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: AppColors.primary),               
            ),
          ),
        ],
      ),
    );
  }

  void _startCooldown() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isCooldown = true;
    });

    _cooldownTimer?.cancel(); // cancel existing timer if any

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final now = DateTime.now();
      final lastResetMillis = prefs.getInt('lastResetTime') ?? now.millisecondsSinceEpoch;
      final lastResetTime = DateTime.fromMillisecondsSinceEpoch(lastResetMillis);
      final elapsed = now.difference(lastResetTime);

      final remaining = const Duration(minutes: 2) - elapsed;

      if (remaining.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isCooldown = false;
          _remainingCooldown = Duration.zero;
        });
      } else {
        setState(() {
          _remainingCooldown = remaining;
        });
      }
    });
  }

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showError("Please enter a valid email.");
      return;
    }

    // Initialize prefs first to avoid crash
    final prefs = await SharedPreferences.getInstance();

    // THEN show dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(width: 20),
            Text("Sending reset link..."),
          ],
        ),
      ),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await prefs.setInt('lastResetTime', DateTime.now().millisecondsSinceEpoch);

      Navigator.pop(context); // close loading dialog

      _startCooldown();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text("Reset Link Sent"),
          content: Text(
            "An email was sent to $email with reset instructions. Please check your spam/junk folder.",
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); 
      _showError(e.code == 'user-not-found'
        ? "No account found for this email."
        : e.message ?? "Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  color: Colors.green,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 2,
                    color: Colors.green,
                    endIndent: 250,
                  ),
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
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isCooldown ? null : _handleReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: 
                        Text(
                          _isCooldown
                            ? "You can request another email in ${_remainingCooldown.inMinutes}:${(_remainingCooldown.inSeconds % 60).toString().padLeft(2, '0')}"
                            : "Send Reset Link",
                          ),

                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailController.dispose();
    super.dispose();
}

}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;  
}
