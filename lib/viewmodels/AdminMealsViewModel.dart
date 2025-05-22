import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart'; // غيّر المسار حسب مكان ملفك

class AdminMealsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void listenToMeals() {
    _isLoading = true;
    notifyListeners();

    _firestore.collection('meals').snapshots().listen((snapshot) {
      _meals =
          snapshot.docs
              .map((doc) => MealModel.fromMap(doc.data(), id: doc.id))
              .toList();
      _isLoading = false;
      notifyListeners();
    });
  }
}
