import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/utils/navigation_utils.dart';
import 'package:meal_app/view/components/admin_components/meal_card.dart';
import 'package:meal_app/view/screens/admin_screens/meals_management/edit_meal.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/user_screens/home/dialogs/confirm_delete_dialog.dart';
import 'package:meal_app/viewmodels/AdminMealsViewModel.dart';
import 'package:provider/provider.dart';

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
          return Dismissible(
            key: ValueKey(meal.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              final confirmed = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return ConfirmDeleteDialog(
                    onConfirm: () {
                      deleteMeal(meal);
                    },
                  );
                },
              );
              // User dismissed the dialog
              return confirmed == true;
            },
            // onDismissed: (direction) {},
            child: MealCard(
              title: meal.name,
              imageUrl: meal.photoUrl,
              type: meal.dietaryType.name,
              timeAndCal: '${meal.duration.label} • ${meal.calories} kcal',
              likes: meal.likes,
              chefs: meal.chefs,
              rating: meal.rating,
              onEdit: () {
                AppNavigator.pushWithoutNavBar(
                  context,
                  EditMealScreen(meal: meal),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
