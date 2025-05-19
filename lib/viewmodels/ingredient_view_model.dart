// lib/viewmodels/ingredient_view_model.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_app/models/ingredient_model.dart';

class IngredientViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Ingredient> _ingredients = [];
  List<Ingredient> get ingredients => _filteredIngredients;

  String _searchQuery = '';
  String _sortMode = 'Category'; // 'A-Z', 'Z-A', etc.
  List<Ingredient> _filteredIngredients = [];

  IngredientViewModel() {
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    final snapshot = await _firestore.collection('ingredients').get();
    _ingredients = snapshot.docs
        .map((doc) => Ingredient.fromMap(doc.data(), doc.id))
        .toList();
    _applyFilters();
  }

  void _applyFilters() {
    List<Ingredient> filtered = _ingredients;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((ing) => ing.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    switch (_sortMode) {
      case 'A-Z':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Category':
      default:
        filtered.sort((a, b) => a.category.compareTo(b.category));
        break;
    }

    _filteredIngredients = filtered;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateSortMode(String mode) {
    _sortMode = mode;
    _applyFilters();
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    final doc = await _firestore.collection('ingredients').add(ingredient.toMap());
    _ingredients.add(Ingredient(id: doc.id, name: ingredient.name, category: ingredient.category));
    _applyFilters();
  }

  Future<void> editIngredient(Ingredient updated) async {
    await _firestore.collection('ingredients').doc(updated.id).update(updated.toMap());
    final index = _ingredients.indexWhere((i) => i.id == updated.id);
    if (index != -1) _ingredients[index] = updated;
    _applyFilters();
  }
}
