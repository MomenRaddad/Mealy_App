import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/view/components/admin_components/custom_dropdown.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';
import 'package:meal_app/utils/size_extensions.dart';

class MealInfoFields extends StatelessWidget {
  final TextEditingController mealNameController;
  final TextEditingController caloriesController;
  final CuisineType selectedCuisine;
  final DurationType selectedDuration;
  final DietaryType selectedDietType;
  final Function(CuisineType) onCuisineChanged;
  final Function(DurationType) onDurationChanged;
  final Function(DietaryType) onDietTypeChanged;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? caloriesValidator;
  final MealDifficulty selectedDifficulty;
  final Function(MealDifficulty) onDifficultyChanged;
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
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
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
                selectedValue: selectedCuisine.toString().split('.').last,
                options:
                    CuisineType.values
                        .map((e) => e.toString().split('.').last)
                        .toList(),
                onSelected:
                    (val) => onCuisineChanged(
                      CuisineType.values.firstWhere(
                        (e) => e.toString().split('.').last == val,
                      ),
                    ),
              ),
            ),
            SizedBox(width: context.wp(10)),
            Expanded(
              child: CustomDropdownField(
                label: 'Duration',
                selectedValue: selectedDuration.label,
                options: DurationType.values.map((e) => e.label).toList(),
                onSelected:
                    (val) => onDurationChanged(
                      DurationType.values.firstWhere((e) => e.label == val),
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.hp(20)),
        Row(
          children: [
            Expanded(
              child: CustomDropdownField(
                label: 'Dietary Type',
                selectedValue: selectedDietType.toString().split('.').last,
                options:
                    DietaryType.values
                        .map((e) => e.toString().split('.').last)
                        .toList(),
                onSelected:
                    (val) => onDietTypeChanged(
                      DietaryType.values.firstWhere(
                        (e) => e.toString().split('.').last == val,
                      ),
                    ),
              ),
            ),
            SizedBox(width: context.wp(10)),
            Expanded(
              child: CustomDropdownField(
                label: 'Difficulty',
                selectedValue: selectedDifficulty.toString().split('.').last,
                options:
                    MealDifficulty.values
                        .map((e) => e.toString().split('.').last)
                        .toList(),
                onSelected:
                    (val) => onDifficultyChanged(
                      MealDifficulty.values.firstWhere(
                        (e) => e.toString().split('.').last == val,
                      ),
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.wp(20)),

        SizedBox(
          width: context.wp(180),
          child: TextFormField(
            controller: caloriesController,
            keyboardType: TextInputType.number,
            decoration: InputStyles.common("Calories"),
            validator: caloriesValidator,
          ),
        ),
      ],
    );
  }
}
