import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add or remove meal from favorites
  Future<void> toggleFavoriteMeal({
    required String userId,
    required String mealId,
  }) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final snapshot = await userDoc.get();
    final Map<String, dynamic> favoriteMeals = Map<String, dynamic>.from(snapshot.data()?['favoriteMeals'] ?? {});

    if (favoriteMeals.containsKey(mealId)) {
      favoriteMeals.remove(mealId);
    } else {
      favoriteMeals[mealId] = DateFormat('dd-MM-yyyy').format(DateTime.now());
    }

    await userDoc.update({'favoriteMeals': favoriteMeals});
  }

  /// Mark meal as visited (add to history)
  Future<void> markMealAsDone({
    required String userId,
    required String mealId,
  }) async {
    final String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    await _firestore.collection('users').doc(userId).set({
      'historyMeals': {
        mealId: date,
      }
    }, SetOptions(merge: true));
  }
}
