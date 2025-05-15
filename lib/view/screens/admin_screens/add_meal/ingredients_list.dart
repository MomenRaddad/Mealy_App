import 'package:flutter/material.dart';
import 'package:meal_app/view/components/admin_components/custom_dropdown.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/core/colors.dart';

// Widget to show the list of ingredients
class IngredientsList extends StatelessWidget {
  final List<Map<String, String>> ingredients;
  final void Function(int) onRemoveIngredient;
  final void Function(int, String) onUnitChanged;
  final bool showError;

  const IngredientsList({
    super.key,
    required this.ingredients,
    required this.onRemoveIngredient,
    required this.onUnitChanged,
    this.showError = false,
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
                    decoration: InputStyles.common("Ingredient").copyWith(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                              showError &&
                                      (ingredient['name']?.trim().isEmpty ??
                                          true)
                                  ? Colors.red
                                  : AppColors.textPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                    validator:
                        (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Required'
                                : null,
                  ),
                ),
                SizedBox(width: context.wp(8)),
                SizedBox(
                  width: context.wp(100),
                  child: TextFormField(
                    initialValue: ingredient['quantity'],
                    decoration: InputStyles.common("Quantity").copyWith(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                              showError &&
                                      (ingredient['quantity']?.trim().isEmpty ??
                                          true)
                                  ? Colors.red
                                  : AppColors.textPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                    validator:
                        (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Required'
                                : null,
                  ),
                ),
                SizedBox(width: context.wp(8)),
                Expanded(
                  child: CustomDropdownField(
                    label: 'Unit',
                    selectedValue: ingredient['unit'] ?? 'liters',
                    options: [
                      'grams',
                      'liters',
                      'pieces',
                      'cups',
                      'tablespoons',
                      'teaspoons',
                    ],
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
