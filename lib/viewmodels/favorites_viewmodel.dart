import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteMeal {
  final String id;
  final String title;
  final String imageUrl;
  final String difficulty;
  final String duration;
  final String addedDate;

  FavoriteMeal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.difficulty,
    required this.duration,
    required this.addedDate,
  });
}

enum SortOption {
  dateDescending,
  dateAscending,
  titleAZ,
  titleZA,
  durationShortLong,
  durationLongShort,
}

class FavoritesViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const defaultImageUrl =
      "https://www.fortessa.com/scs/extensions/MHI/FortessaB2C/3.1.0/img/no_image_available.jpeg";

  List<FavoriteMeal> _meals = [];
  bool _isLoading = false;

  List<FavoriteMeal> get meals => _meals;
  bool get isLoading => _isLoading;

  SortOption _currentSort = SortOption.dateDescending;
  SortOption get currentSort => _currentSort;

  void setSortOption(SortOption option) {
    _currentSort = option;
    notifyListeners();
  }

  Future<void> removeFavoriteMealFromUser(String userId, String mealId) async {
    try {
      await _db.collection('users').doc(userId).update({
        "favoriteMeals.$mealId": FieldValue.delete(),
      });

      // Also remove from the local list
      _meals.removeWhere((meal) => meal.id == mealId);
      notifyListeners();

      debugPrint("❌❌Removed $mealId from user $userId favorites.");
    } catch (e) {
      debugPrint("Error deleting favorite: $e");
    }
  }


  Future<void> fetchFavoriteMeals(String userId) async {
    debugPrint("Fetching user: $userId");

    _isLoading = true;
    notifyListeners();

    try {
      final userDoc = await _db.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> favorites = userDoc.data()?['favoriteMeals'] ?? {};
      _meals.clear();

      if (favorites.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      for (final entry in favorites.entries) {
        final mealId = entry.key;
        final addedDate = entry.value;

        final mealDoc = await _db.collection('meals').doc(mealId).get();
        if (mealDoc.exists) {
          final data = mealDoc.data()!;
          final image = data['photoUrl'] ?? defaultImageUrl;

          _meals.add(FavoriteMeal(
            id: mealId,
            title: data['name'] ?? 'Untitled Meal',
            imageUrl: image,
            difficulty: data['difficulty'] ?? 'Unknown',
            duration: data['duration'] ?? 'N/A',
            addedDate: addedDate,
          ));

          debugPrint("Added meal: $mealId (${data['name']}) on $addedDate, with image: $image");
        }
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void removeFavoriteAt(int index) {
    _meals.removeAt(index);
    notifyListeners();
  }

  Map<String, List<FavoriteMeal>> get groupedFavorites {
    Map<String, List<FavoriteMeal>> grouped = {};

    for (var meal in _meals) {
      grouped.putIfAbsent(meal.addedDate, () => []).add(meal);
    }

    // Sort meals inside each group
    for (var entry in grouped.entries) {
      entry.value.sort((a, b) => _sortMeals(a, b));
    }

    // Sort the group keys (dates)
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        final aDate = _parseDmy(a.key) ?? DateTime(1900);
        final bDate = _parseDmy(b.key) ?? DateTime(1900);
        return _currentSort == SortOption.dateAscending
            ? aDate.compareTo(bDate)
            : bDate.compareTo(aDate);
      });

    return Map.fromEntries(sortedEntries);
  }

  int _sortMeals(FavoriteMeal a, FavoriteMeal b) {
    switch (_currentSort) {
      case SortOption.titleAZ:
        return a.title.compareTo(b.title);
      case SortOption.titleZA:
        return b.title.compareTo(a.title);
      case SortOption.durationShortLong:
        return _parseDuration(a.duration).compareTo(_parseDuration(b.duration));
      case SortOption.durationLongShort:
        return _parseDuration(b.duration).compareTo(_parseDuration(a.duration));
      default:
        return 0; // skip internal sorting for date-based
    }
  }

  int _parseDuration(String duration) {
    final number = RegExp(r'\d+').firstMatch(duration)?.group(0);
    return int.tryParse(number ?? '') ?? 0;
  }

  DateTime? _parseDmy(String dmy) {
    final parts = dmy.split('-');
    if (parts.length != 3) return null;
    return DateTime.tryParse(
      '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}',
    );
  }
}
