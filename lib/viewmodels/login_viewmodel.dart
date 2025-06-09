import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> login(String email, String password, {bool rememberMe = false}) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return "No account data found for this email.";
      }

      final data = query.docs.first.data();
      final status = data['accountStatus']?.toString().toLowerCase();
      if (status != 'active') {
        return "Your account is not active and has been suspended.\nPlease contact support or wait for approval.\n\n-Status: $status\n-Email: $email\n-UID: ${data['userId']}";
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) return 'User not found';

      // Save remember me
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('rememberMe', true);
      }

      UserSession.fromMap(data);

      // Track unique daily login
      final today = DateTime.now();
      final docId = "${today.year}-${today.month}-${today.day}";

      final loginRef = _firestore.collection('daily_logins').doc(docId);
      final loginSnap = await loginRef.get();

      if (!loginSnap.exists || !(loginSnap.data()?['uids'] ?? []).contains(user.uid)) {
        await loginRef.set({
          'uids': FieldValue.arrayUnion([user.uid]),
          'date': today.toIso8601String(),
        }, SetOptions(merge: true));
      }

      // Track daily visits
      final visitRef = _firestore.collection('daily_visits').doc(docId);
      await visitRef.set({
        'visits': FieldValue.increment(1),
        'date': today.toIso8601String(),
      }, SetOptions(merge: true));

      return null; // Success

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with the email `$email`.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'invalid-credential':
          return 'The credentials are invalid or expired.\nThis can happen if the email is unregistered or the password is incorrect.';
        default:
          return e.message ?? 'Login failed. Please try again.';
      }
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  } 
}