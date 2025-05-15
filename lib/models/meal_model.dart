enum DietaryType { vegan, vegetarian, keto, regular }

enum DurationType { less15min, min15to30, min30to60, more60min }

enum CuisineType { italian, arabic, asian, american, indian, other }

enum UnitType { g, ml, pcs, cups, Tbsp, Tsp }

enum MealDifficulty { easy, medium, hard }

extension DurationTypeLabel on DurationType {
  String get label {
    switch (this) {
      case DurationType.less15min:
        return '< 15 min';
      case DurationType.min15to30:
        return '15–30 min';
      case DurationType.min30to60:
        return '30–60 min';
      case DurationType.more60min:
        return '> 60 min';
    }
  }
}

class MealIngredient {
  final String name;
  final String quantity;
  final UnitType unit;

  MealIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory MealIngredient.fromMap(Map<String, dynamic> map) {
    return MealIngredient(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      unit: UnitType.values.firstWhere(
        (e) => e.toString().split('.').last == (map['unit'] ?? 'g'),
        orElse: () => UnitType.g,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit.toString().split('.').last,
    };
  }
}

class MealModel {
  final String? id;
  final String name;
  final String photoUrl;
  final CuisineType cuisine;
  final DurationType duration;
  final int calories;
  final DietaryType dietaryType;
  final List<MealIngredient> ingredients;
  final String steps;
  final double rating;
  final MealDifficulty difficulty;
  MealModel({
    this.id,
    required this.name,
    required this.photoUrl,
    required this.cuisine,
    required this.duration,
    required this.calories,
    required this.dietaryType,
    required this.ingredients,
    required this.steps,
    required this.rating,
    required this.difficulty,
  });

  factory MealModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return MealModel(
      id: id,
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      cuisine: CuisineType.values.firstWhere(
        (e) => e.toString().split('.').last == (map['cuisine'] ?? 'other'),
        orElse: () => CuisineType.other,
      ),
      duration: DurationType.values.firstWhere(
        (e) => e.toString().split('.').last == (map['duration'] ?? 'min15to30'),
        orElse: () => DurationType.min15to30,
      ),
      calories:
          map['calories'] is int
              ? map['calories']
              : int.tryParse(map['calories'].toString()) ?? 0,
      dietaryType: DietaryType.values.firstWhere(
        (e) =>
            e.toString().split('.').last == (map['dietaryType'] ?? 'regular'),
        orElse: () => DietaryType.regular,
      ),
      ingredients:
          (map['ingredients'] ?? [])
              .map<MealIngredient>((e) => MealIngredient.fromMap(e))
              .toList(),
      steps: map['steps'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      difficulty: MealDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == (map['difficulty'] ?? 'easy'),
        orElse: () => MealDifficulty.easy,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'cuisine': cuisine.toString().split('.').last,
      'duration': duration.toString().split('.').last,
      'calories': calories,
      'dietaryType': dietaryType.toString().split('.').last,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'steps': steps,
      'rating': rating,
      'difficulty': difficulty.toString().split('.').last,
    };
  }
}
