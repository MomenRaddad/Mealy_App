import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/view/components/admin_components/meal_card.dart';
import 'package:meal_app/view/screens/admin_screens/meals_management/edit_meal.dart';
import 'package:meal_app/utils/size_extensions.dart';

class MealsList extends StatelessWidget {
  final List<MealModel> filteredMeals;

  const MealsList({super.key, required this.filteredMeals});

  @override
  Widget build(BuildContext context) {
    if (filteredMeals.isEmpty) {
      return const Center(child: Text("No meals match your search/filter."));
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.hp(8),
        horizontal: context.wp(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredMeals.length,
        itemBuilder: (context, index) {
          final meal = filteredMeals[index];
          return MealCard(
            title: meal.name,
            imageUrl: meal.photoUrl,
            type: meal.dietaryType.name,
            timeAndCal: '${meal.duration.label} • ${meal.calories} kcal',
            likes: meal.likes,
            chefs: meal.chefs,
            rating: meal.rating,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditMealScreen(meal: meal)),
              );
            },
          );
        },
      ),
    );
  }
}
