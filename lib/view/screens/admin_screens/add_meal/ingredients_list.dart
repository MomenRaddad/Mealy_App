import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/view/components/admin_components/custom_dropdown.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/ingredient_management/ingredient_management_screen.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/input_styles.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/viewmodels/ingredient_view_model.dart';
import 'package:provider/provider.dart';

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
  final List<TextEditingController> _nameControllers = [];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
  // Only add controllers if list is shorter than ingredients
  if (_nameControllers.length < widget.ingredients.length) {
    final additionalControllers = widget.ingredients
        .skip(_nameControllers.length)
        .map((ingredient) => TextEditingController(text: ingredient['name']))
        .toList();

    _nameControllers.addAll(additionalControllers);
  }
}


  @override
  void didUpdateWidget(covariant IngredientsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ingredients.length != widget.ingredients.length) {
      _initControllers();
    }
  }

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initControllers();
    
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
                    controller: _nameControllers[index],
                    readOnly: true,
                    decoration: InputStyles.common("Ingredient"),
                    validator: (val) =>
                        (val == null || val.trim().isEmpty) ? 'Required' : null,
                    onTap: () async {
                      final selectedName = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => IngredientViewModel(),
                            child: const IngredientManagementScreen(isPickerMode: true),
                          ),
                        ),
                      );

                      if (selectedName != null && selectedName.trim().isNotEmpty) {
                        setState(() {
                          _nameControllers[index].text = selectedName.trim();
                          widget.ingredients[index]['name'] = selectedName.trim();
                        });
                      }
                    },
                    onChanged: (val) =>
                        widget.ingredients[index]['name'] = val.trim(),
                  ),
                ),
                SizedBox(width: context.wp(8)),

                SizedBox(
                  width: context.wp(100),
                  child: TextFormField(
                    initialValue: ingredient['quantity'],
                    decoration: InputStyles.common("Qty"),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        (val == null || val.trim().isEmpty) ? 'Required' : null,
                    onChanged: (val) =>
                        widget.ingredients[index]['quantity'] = val.trim(),
                  ),
                ),
                SizedBox(width: context.wp(8)),

                Expanded(
                  child: CustomDropdownField(
                    label: 'Unit',
                    selectedValue: ingredient['unit'] ?? 'g',
                    options: UnitType.values
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
