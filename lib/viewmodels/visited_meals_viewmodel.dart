import 'package:flutter/material.dart';
import '../../models/visited_meal_model.dart';

class VisitedMealsViewModel extends ChangeNotifier {
  final List<VisitedMeal> _visitedMeals = [];

  List<VisitedMeal> get visitedMeals => _visitedMeals;

  void addMeal(VisitedMeal meal) {
    if (_visitedMeals.any((m) => m.id == meal.id)) return;
    _visitedMeals.insert(0, meal); 
    notifyListeners();
  }
}
