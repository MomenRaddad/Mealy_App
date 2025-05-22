import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';

class EditMealViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  Future<void> updateMeal({
    required MealModel meal,
    required String name,
    required String cuisine,
    required String duration,
    required String calories,
    required String dietaryType,
    required List<Map<String, String>> ingredients,
    required String steps,
    required File? imageFile,
    required String difficulty,
  }) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String photoUrl = meal.photoUrl;

      if (imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = _storage.ref().child('meal_images').child(fileName);
        print("39");
        await ref.putFile(imageFile, SettableMetadata());
        print("41");

        photoUrl = await ref.getDownloadURL();
      }

      final updatedMeal = meal.copyWith(
        name: name,
        photoUrl: photoUrl,
        cuisine: CuisineType.values.firstWhere(
          (e) => e.toString().split('.').last == cuisine,
        ),
        duration: DurationType.values.firstWhere(
          (e) => e.toString().split('.').last == duration,
        ),
        calories: int.tryParse(calories) ?? 0,
        dietaryType: DietaryType.values.firstWhere(
          (e) => e.toString().split('.').last == dietaryType,
        ),
        steps: steps,
        ingredients:
            ingredients.map((e) {
              return MealIngredient(
                name: e['name']!,
                quantity: e['quantity']!,
                unit: UnitType.values.firstWhere(
                  (u) => u.toString().split('.').last == e['unit'],
                ),
              );
            }).toList(),
        difficulty: MealDifficulty.values.firstWhere(
          (e) => e.toString().split('.').last == difficulty,
        ),
      );

      await _firestore
          .collection('meals')
          .doc(meal.id)
          .update(updatedMeal.toMap());
    } catch (e) {
      errorMessage = 'Failed to update meal: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
