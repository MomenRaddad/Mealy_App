import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/components/admin_components/meal_card.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/add_meal.dart';
import 'package:meal_app/view/screens/admin_screens/meals_management/edit_meal.dart';
import 'package:meal_app/viewmodels/AdminMealsViewModel.dart';
import 'package:provider/provider.dart';

class MealsManagementScreen extends StatelessWidget {
  const MealsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminMealsViewModel>(context);

    // if (viewModel.meals.isEmpty && !viewModel.isLoading) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     viewModel.fetchMeals();
    //   });
    // }
    if (viewModel.meals.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.listenToMeals();
      });
      return const Center(
        child: Text('No meals available', style: TextStyle(fontSize: 18)),
      );
    }

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.hp(14),
          horizontal: context.wp(23),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: viewModel.meals.length,
          itemBuilder: (context, index) {
            final meal = viewModel.meals[index];

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
      ),
    );
  }
}
