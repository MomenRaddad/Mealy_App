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

      // Initialize session
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data != null) {
        UserSession.fromMap(data);
      }

      // Track unique daily login
      final today = DateTime.now();
      final docId = "${today.year}-${today.month}-${today.day}";

      // LOGIN LOGIC
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
      return e.message ?? 'Login failed';
    } catch (e) {
      return 'An error occurred';
    }
  }

}