import 'package:flutter/material.dart';
import 'package:meal_app/models/ingredient_model.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/ingredient_management/ingredient_tile.dart';
import 'package:meal_app/viewmodels/ingredient_view_model.dart';
import 'package:provider/provider.dart';

class IngredientManagementScreen extends StatelessWidget {
  final bool isPickerMode;  
      
  const IngredientManagementScreen({super.key, this.isPickerMode = false});

  void _showAddDialog(BuildContext context, {Ingredient? ingredient}) {
    final nameController = TextEditingController(text: ingredient?.name);
    final categoryController = TextEditingController(text: ingredient?.category);

    final List<String> validCategories = [
      'Vegetable',
      'Meat',
      'Spice',
      'Dairy',
      'Other',
    ];

    final isEditing = ingredient != null;
    final incomingCategory = categoryController.text;
    final isInvalidCategory =
        isEditing && !validCategories.contains(incomingCategory);

    final String initialCategory =
        isInvalidCategory ? 'Other' : incomingCategory;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ingredient == null ? 'Add Ingredient' : 'Edit Ingredient'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              if (isInvalidCategory)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "⚠️ Category '$incomingCategory' is invalid and has been reset to 'Other'.",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              DropdownButtonFormField<String>(
                value: initialCategory.isEmpty ? null : initialCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: validCategories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    categoryController.text = value;
                  }
                },
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final viewModel = Provider.of<IngredientViewModel>(context, listen: false);
              final name = nameController.text.trim();
              final category = categoryController.text.trim();

              if (name.isEmpty || category.isEmpty) return;

              if (ingredient == null) {
                viewModel.addIngredient(Ingredient(id: '', name: name, category: category));
              } else {
                viewModel.editIngredient(Ingredient(id: ingredient.id, name: name, category: category));
              }

              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Management'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => context.read<IngredientViewModel>().updateSortMode(val),
            itemBuilder: (_) => ['Category', 'A-Z', 'Z-A']
                .map((e) => PopupMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
        ],
      ),
      floatingActionButton: isPickerMode
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _showAddDialog(context),
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search ingredients...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => context.read<IngredientViewModel>().updateSearch(val),
            ),
          ),
          Expanded(
            child: Consumer<IngredientViewModel>(
              builder: (_, viewModel, __) {
                if (viewModel.ingredients.isEmpty) {
                  return const Center(child: Text('No ingredients found.'));
                }

                final groupedIngredients = <String, List<Ingredient>>{};
                for (var ing in viewModel.ingredients) {
                  groupedIngredients.putIfAbsent(ing.category, () => []).add(ing);
                }

                return ListView(
                  children: groupedIngredients.entries.map((entry) {
                    final category = entry.key;
                    final items = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        ...items.map((ing) => IngredientTile(
                          ingredient: ing,
                          onTap: isPickerMode
                              ? () => Navigator.pop(context, ing.name)
                              : () {},
                          onEdit: () => _showAddDialog(context, ingredient: ing),
                          onDelete: () => context.read<IngredientViewModel>().deleteIngredient(ing.id),
                        )),
                        const Divider(),

                      ],
                    );
                  }).toList(),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
