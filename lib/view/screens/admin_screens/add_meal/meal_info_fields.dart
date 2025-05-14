import 'package:flutter/material.dart';
import 'package:meal_app/view/components/admin_components/custom_dropdown.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';
import 'package:meal_app/utils/size_extensions.dart';

// This widget shows the fields for meal info
class MealInfoFields extends StatelessWidget {
  final TextEditingController mealNameController;
  final TextEditingController caloriesController;
  final String selectedCuisine;
  final String selectedDuration;
  final String selectedDietType;
  final Function(String) onCuisineChanged;
  final Function(String) onDurationChanged;
  final Function(String) onDietTypeChanged;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? caloriesValidator;

  const MealInfoFields({
    super.key,
    required this.mealNameController,
    required this.caloriesController,
    required this.selectedCuisine,
    required this.selectedDuration,
    required this.selectedDietType,
    required this.onCuisineChanged,
    required this.onDurationChanged,
    required this.onDietTypeChanged,
    this.nameValidator,
    this.caloriesValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: mealNameController,
          decoration: InputStyles.common("Meal Name"),
          validator: nameValidator,
        ),
        SizedBox(height: context.hp(20)),
        Row(
          children: [
            Expanded(
              child: CustomDropdownField(
                label: 'Cuisine',
                selectedValue: selectedCuisine,
                options: [
                  'Italian',
                  'Mexican',
                  'Arabic',
                  'Asian',
                  'American',
                  'Indian',
                ],
                onSelected: onCuisineChanged,
              ),
            ),
            SizedBox(width: context.wp(10)),
            Expanded(
              child: CustomDropdownField(
                label: 'Duration',
                selectedValue: selectedDuration,
                options: ['less15min', 'min15to30', 'min30to60', 'more60min'],
                onSelected: onDurationChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: context.hp(20)),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputStyles.common("Calories"),
                validator: caloriesValidator,
              ),
            ),
            SizedBox(width: context.wp(10)),
            Expanded(
              child: CustomDropdownField(
                label: 'Dietary Type',
                selectedValue: selectedDietType,
                options: ['Regular', 'Vegan', 'Keto', 'Vegetarian'],
                onSelected: onDietTypeChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() =>
      this.isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
