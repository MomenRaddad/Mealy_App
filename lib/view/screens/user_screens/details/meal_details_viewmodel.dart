import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MealDetailsViewModel extends ChangeNotifier {
  Map<String, dynamic>? meal;
  bool isLoading = false;

  Future<void> loadMealById(String mealId) async {
    isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('meals')
          .doc(mealId)
          .get();

      meal = doc.data();
    } catch (e) {
      debugPrint("❌ Failed to load meal details: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
