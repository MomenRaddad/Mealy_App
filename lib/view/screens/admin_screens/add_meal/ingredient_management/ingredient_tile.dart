import 'package:flutter/material.dart';
import 'package:meal_app/models/ingredient_model.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const IngredientTile({
    required this.ingredient,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(ingredient.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool confirmed = false;
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Are you sure you want to delete "${ingredient.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  confirmed = true;
                  Navigator.of(ctx).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed) onDelete();
        return confirmed;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(ingredient.name),
        subtitle: Text(ingredient.category),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
