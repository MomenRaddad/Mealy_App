import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;

  Future<void> fetchUserProfile(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance.collection('profile').doc(userId).get();
      if (doc.exists) {
        user = UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint("❌ Error fetching user profile: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserProfile(UserModel updated) async {
    try {
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(updated.userId)
          .update(updated.toMap());

      user = updated;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error updating user profile: $e");
    }
  }
}
