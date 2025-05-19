import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MealDetailsViewModel extends ChangeNotifier {
  Map<String, dynamic>? meal;
  bool isLoading = true;

  Future<void> loadMealById(String id) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('mealsList').doc(id).get();
      if (doc.exists) {
        meal = doc.data();
      }
    } catch (e) {
      debugPrint("❌ Error loading meal: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> markMealAsDone(String mealId, String title, String image) async {
    final mealRef = FirebaseFirestore.instance.collection('mealsList').doc(mealId);

    try {
      await mealRef.update({'doneCount': FieldValue.increment(1)});

      final historyRef = FirebaseFirestore.instance.collection('visitedMeals');
      await historyRef.add({
        'mealId': mealId,
        'title': title,
        'image': image,
        'visitedAt': DateTime.now(),
      });
    } catch (e) {
      debugPrint("❌ Failed to mark meal as done: $e");
    }
  }
}
