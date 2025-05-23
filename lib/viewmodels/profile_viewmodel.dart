import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;

  /// Fetch user data using Firestore
  Future<void> fetchUserProfile(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance.collection('profile').doc(userId).get();
      if (doc.exists) {
        user = UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint("❌ Error fetching user profile: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    await fetchUserProfile("1"); 
  }


  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(updatedUser.userId)
          .update(updatedUser.toJson());

      user = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error updating user profile: $e");
    }
  }
}
