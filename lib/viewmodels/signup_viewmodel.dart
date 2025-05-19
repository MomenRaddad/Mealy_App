import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class SignUpViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String gender,
    required DateTime dateOfBirth,
    bool isAdmin = false,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      UserModel user = UserModel(
        userId: uid,
        name: name,
        email: email,
        password: password,
        privilegedUser: false,
        dateOfBirth: dateOfBirth,
        gender: gender,
        createdAt: DateTime.now(),
        accountStatus: AccountStatus.active,
      );

      await _firestore.collection('users').doc(uid).set(user.toJson());

      return null;
    } on FirebaseAuthException catch (e) {
      print(" FirebaseAuthException: ${e.message}");
      return e.message;
    } catch (e) {
      print(" General Exception: $e");
      return 'Something went wrong';
    }
  }
}
