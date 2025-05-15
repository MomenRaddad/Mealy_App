import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/view/components/admin_components/custom_dropdown.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/core/colors.dart';

class IngredientsList extends StatefulWidget {
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
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
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
        ...widget.ingredients.asMap().entries.map((entry) {
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
                    validator:
                        (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Required'
                                : null,
                    onChanged:
                        (val) => widget.ingredients[index]['name'] = val.trim(),
                  ),
                ),
                SizedBox(width: context.wp(8)),

                SizedBox(
                  width: context.wp(100),
                  child: TextFormField(
                    initialValue: ingredient['quantity'],
                    decoration: InputStyles.common("Qty"),
                    keyboardType: TextInputType.number,
                    validator:
                        (val) =>
                            (val == null || val.trim().isEmpty)
                                ? 'Required'
                                : null,
                    onChanged:
                        (val) =>
                            widget.ingredients[index]['quantity'] = val.trim(),
                  ),
                ),
                SizedBox(width: context.wp(8)),

                Expanded(
                  child: CustomDropdownField(
                    label: 'Unit',
                    selectedValue: ingredient['unit'] ?? 'g',
                    options:
                        UnitType.values
                            .map((e) => e.toString().split('.').last)
                            .toList(),
                    onSelected: (val) => widget.onUnitChanged(index, val),
                  ),
                ),

                IconButton(
                  onPressed: () => widget.onRemoveIngredient(index),
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
