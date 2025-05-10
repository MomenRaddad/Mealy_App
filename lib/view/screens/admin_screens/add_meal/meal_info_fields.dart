import 'package:flutter/material.dart';
import 'package:meal_app/view/components/admin_components/custom_dropdown.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';
import 'package:meal_app/utils/size_extensions.dart';

class MealInfoFields extends StatelessWidget {
  final TextEditingController mealNameController;
  final String selectedCuisine;
  final String selectedDuration;
  final String selectedDietType;
  final Function(String) onCuisineChanged;
  final Function(String) onDurationChanged;
  final Function(String) onDietTypeChanged;

  const MealInfoFields({
    super.key,
    required this.mealNameController,
    required this.selectedCuisine,
    required this.selectedDuration,
    required this.selectedDietType,
    required this.onCuisineChanged,
    required this.onDurationChanged,
    required this.onDietTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: mealNameController,
          decoration: InputStyles.common("Meal Name"),
        ),
        SizedBox(height: context.hp(20)),
        Row(
          children: [
            Expanded(
              child: CustomDropdownField(
                label: 'Cuisine',
                selectedValue: selectedCuisine,
                options: ['Italian', 'Mexican', 'Arabic'],
                onSelected: onCuisineChanged,
              ),
            ),
            SizedBox(width: context.wp(10)),
            Expanded(
              child: CustomDropdownField(
                label: 'Duration',
                selectedValue: selectedDuration,
                options: ['~10 mins', '~30 mins', '~1 hour'],
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
                keyboardType: TextInputType.number,
                initialValue: '1345',
                decoration: InputStyles.common("Calories"),
                readOnly: false,
              ),
            ),
            SizedBox(width: context.wp(10)),
            Expanded(
              child: CustomDropdownField(
                label: 'Dietary Type',
                selectedValue: selectedDietType,
                options: ['None', 'Vegan', 'Keto'],
                onSelected: onDietTypeChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
