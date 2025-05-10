import 'package:flutter/material.dart';
import 'package:meal_app/view/components/admin_components/custom_dropdown.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/core/colors.dart';

class IngredientsList extends StatelessWidget {
  final List<Map<String, String>> ingredients;
  final void Function(int) onRemoveIngredient;
  final void Function(int, String) onUnitChanged;

  const IngredientsList({
    super.key,
    required this.ingredients,
    required this.onRemoveIngredient,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.hp(12)),
        ...ingredients.asMap().entries.map((entry) {
          int index = entry.key;
          var ingredient = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: context.hp(15)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: ingredient['name'],
                    decoration: InputStyles.common("Ingredient"),
                  ),
                ),
                SizedBox(width: context.wp(8)),
                SizedBox(
                  width: context.wp(100),
                  child: TextFormField(
                    initialValue: ingredient['quantity'],
                    decoration: InputStyles.common("Quantity"),
                  ),
                ),
                SizedBox(width: context.wp(8)),
                Expanded(
                  child: CustomDropdownField(
                    label: 'Unit',
                    selectedValue: ingredient['unit'] ?? 'liter',
                    options: ['liter', 'gram', 'piece'],
                    onSelected: (val) => onUnitChanged(index, val),
                  ),
                ),
                IconButton(
                  onPressed: () => onRemoveIngredient(index),
                  icon: const Icon(Icons.delete, color: AppColors.error),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
