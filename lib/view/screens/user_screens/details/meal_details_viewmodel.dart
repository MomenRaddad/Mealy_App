import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MealDetailsViewModel extends ChangeNotifier {
  Map<String, dynamic>? meal;
  bool isLoading = true;

  Future<void> loadMealById(String id) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('meals').doc(id).get();
      if (doc.exists) {
        meal = doc.data();
      }
    } catch (e) {
      debugPrint("\u274c Error loading meal: \$e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> markMealAsDone(String mealId, String title, String image) async {
    final mealRef = FirebaseFirestore.instance.collection('meals').doc(mealId);

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
      debugPrint("\u274c Failed to mark meal as done: \$e");
    }
  }
  Future<void> undoMealAsDone(String mealId, String title) async {
  final mealRef = FirebaseFirestore.instance.collection('meals').doc(mealId);

  try {
    // 👇 أنقص العداد إذا كان أكبر من 0
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(mealRef);
      final currentCount = snapshot.get('doneCount') ?? 0;
      if (currentCount > 0) {
        transaction.update(mealRef, {'doneCount': currentCount - 1});
      }
    });

    // 👇 احذف من visitedMeals إذا موجود
    final historyRef = FirebaseFirestore.instance
        .collection('visitedMeals')
        .where('mealId', isEqualTo: mealId)
        .where('title', isEqualTo: title)
        .limit(1);

    final snapshot = await historyRef.get();
    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.delete();
    }
  } catch (e) {
    debugPrint("❌ Failed to undo meal: $e");
  }
}


}