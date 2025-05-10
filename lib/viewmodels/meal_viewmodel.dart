import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<void> addMeal({
    required String name,
    required String cuisine,
    required String duration,
    required String calories,
    required String dietaryType,
    required List<Map<String, String>> ingredients,
    required String steps,
    File? imageFile,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      String? imageUrl;

      if (imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('meal_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        print(' Uploading image: ${imageFile.path}');
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        await ref.putFile(imageFile, metadata);
        print(' Image uploaded!');
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('meals').add({
        'name': name,
        'cuisine': cuisine,
        'duration': duration,
        'calories': calories,
        'dietaryType': dietaryType,
        'ingredients': ingredients,
        'steps': steps,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      errorMessage = null;
    } catch (e) {
      errorMessage = 'Something went wrong: ${e.toString()}';
      print(' Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
