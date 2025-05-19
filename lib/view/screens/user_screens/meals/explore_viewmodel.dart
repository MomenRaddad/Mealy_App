import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ExploreViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> meals = [];

  Future<void> loadMeals() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('mealsList').get();

      meals = snapshot.docs.map((doc) {
        final data = doc.data();

        return {
          'id': doc.id,
          'title': data['title'] ?? 'Untitled Meal',
          'image': data['image'] ?? '',
          'difficulty': data['difficulty'] ?? 'Unknown',
          'duration': data['duration'] ?? '',
          'ingredients': data['ingredients'] ?? [],
          'steps': data['steps'] ?? [],
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error loading meals from Firestore: $e");
    }
  }
}
