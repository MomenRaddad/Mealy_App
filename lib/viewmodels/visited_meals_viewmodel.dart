import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_app/models/visited_meal_model.dart';

class VisitedMealsViewModel extends ChangeNotifier {
  List<VisitedMeal> visitedMeals = [];

  Future<void> fetchVisitedMeals() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('visitedMeals')
        .orderBy('visitedAt', descending: true)
        .get();

    visitedMeals = snapshot.docs.map((doc) {
      final data = doc.data();
      return VisitedMeal(
        id: data['mealId'],
        title: data['title'],
        image: data['image'],
        visitedAt: (data['visitedAt'] as Timestamp).toDate(),
      );
    }).toList();

    notifyListeners();
  }
}
