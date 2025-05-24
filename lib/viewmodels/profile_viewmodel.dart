import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;


  Future<void> fetchUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint("No user is logged in.");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection("profile")
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        user = UserModel.fromJson(doc.data()!);
      } else {
        debugPrint("⚠️ No user found with docId: ${currentUser.uid}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching user profile: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserProfileByUserId(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final query = await FirebaseFirestore.instance
          .collection('profile')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        user = UserModel.fromJson(query.docs.first.data());
      } else {
        debugPrint("⚠️ No user found with userId: $userId");
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch user: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    const String staticUserId = "dQUiUzPnVzLMj4tCHQkpRLtcDwW2"; 
    await fetchUserProfileByUserId(staticUserId);
  }

  Future<void> updateUserProfile(UserModel updated) async {
    try {
      final docId = updated.userId; 

      await FirebaseFirestore.instance
          .collection('profile')
          .doc(docId)
          .update(updated.toJson());

      user = updated;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error updating user profile: $e");
    }
  }
}
