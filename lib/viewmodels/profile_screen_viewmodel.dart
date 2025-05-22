import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/models/userProfile.dart';

class ProfileViewModel extends ChangeNotifier {
  UserProfile? user;
  bool isLoading = false;

  Future<void> loadUserProfile(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance.collection('profile').doc(userId).get();
      if (doc.exists) {
        user = UserProfile.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint("Failed to load profile: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String> uploadImage(XFile file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    await FirebaseFirestore.instance.collection('profile').doc(userId).update(updates);
    await loadUserProfile(userId); // reload updated data
  }
}
