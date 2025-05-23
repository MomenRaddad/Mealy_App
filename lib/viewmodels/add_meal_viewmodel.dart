import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

// ViewModel to handle adding a meal
class AddMealViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // This function uploads an image to Firebase Storage and returns its URL
  Future<String> uploadImage(File imageFile) async {
    print('uploadImage called');
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child(
        'meals/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      print('Uploading image to ${imageRef.fullPath}');
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await imageRef.putFile(imageFile, metadata);
      print('Image uploaded, getting download URL');
      final url = await imageRef.getDownloadURL();
      print('Download URL: $url');
      return url;
    } catch (e, stack) {
      print('UploadImage error: $e');
      print(stack);
      rethrow;
    }
  }

  // This function uploads the default image from assets if the user didn't pick an image
  Future<String> uploadDefaultImage() async {
    print('uploadDefaultImage called');
    try {
      final byteData = await rootBundle.load('assets/images/default_meal.jpg');
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/default_meal.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());
      return await uploadImage(tempFile);
    } catch (e, stack) {
      print('UploadDefaultImage error: $e');
      print(stack);
      return '';
    }
  }

  // This function adds a meal to Firestore, with image upload if needed
  Future<void> addMeal({
    required String name,
    required String cuisine,
    required String duration,
    required String calories,
    required String dietaryType,
    required List<Map<String, String>> ingredients,
    required String steps,
    File? imageFile,
    required String difficulty,
  }) async {
    print('addMeal called');
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      String? photoUrl;
      if (imageFile != null) {
        // If user picked an image, upload it
        print('Image file provided');
        photoUrl = await uploadImage(imageFile);
        print('Image uploaded, url: $photoUrl');
      } else {
        // If no image picked, upload the default image
        print('No image file provided, uploading default image');
        photoUrl = await uploadDefaultImage();
        print('Default image uploaded, url: $photoUrl');
      }
      print('Adding meal to Firestore');
      await FirebaseFirestore.instance.collection('meals').add({
        'name': name,
        'cuisine': cuisine,
        'duration': duration,
        'calories': calories,
        'dietaryType': dietaryType,
        'ingredients': ingredients,
        'steps': steps,
        'photoUrl': photoUrl,
        'difficulty': difficulty,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Meal added to Firestore successfully');
      errorMessage = null;
    } catch (e, stack) {
      errorMessage = ' went wrong: ${e.toString()}';
      print('Error: $e');
      print(stack);
    } finally {
      isLoading = false;
      notifyListeners();
      print('addMeal finished, isLoading set to false');
    }
  }
}
