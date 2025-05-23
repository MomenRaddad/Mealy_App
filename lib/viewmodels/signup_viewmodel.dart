import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_app/models/user_model.dart';

class SignUpViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String gender,
    required DateTime dateOfBirth,
    required bool isAdmin,
    required String phoneNumber, 
  }) async {
    try {
      // Firebase Auth registration
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCred.user!.uid;

      // Build UserModel
      UserModel user = UserModel(
        userId: uid,
        userName: name,
        userEmail: email,
        DOB: dateOfBirth,
        gender: gender,
        isPrivileged: isAdmin,
        accountStatus: AccountStatus.active,
        createdAt: DateTime.now(),
        phoneNumber: phoneNumber,
      );

      // Save to Firestore
      await _firestore.collection("users").doc(uid).set(user.toJson());

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Authentication failed";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }
}