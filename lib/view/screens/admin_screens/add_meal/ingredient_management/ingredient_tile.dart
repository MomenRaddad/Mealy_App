import 'package:flutter/material.dart';
import 'package:meal_app/models/ingredient_model.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const IngredientTile({
    required this.ingredient,
    required this.onTap,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(ingredient.name),
      subtitle: Text(ingredient.category),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: onEdit,
      ),
    );
  }
}

