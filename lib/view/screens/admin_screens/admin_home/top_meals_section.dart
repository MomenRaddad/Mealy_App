import 'package:flutter/material.dart';

import 'package:meal_app/view/components/admin_components/meal_card.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/meals_test_data.dart';

class TopMealsSection extends StatelessWidget {
  const TopMealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Top Meals", style: Theme.of(context).textTheme.headlineLarge),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return MealCard(
              title: meal.title,
              imageUrl: meal.imageUrl,
              type: meal.type,
              timeAndCal: meal.timeAndCal,
              likes: meal.likes,
              chefs: meal.chefs,
              rating: meal.rating,
            );
          },
        ),
      ],
    );
  }
}
