import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/viewmodels/meal_viewmodel.dart';

import 'meal_image_picker.dart';
import 'meal_info_fields.dart';
import 'ingredients_list.dart';
import 'add_ingredient_button.dart';
import 'steps_field.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  File? _selectedImage;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final TextEditingController _caloriesController = TextEditingController(
    text: '1345',
  );
  final TextEditingController _mealNameController = TextEditingController(
    text: 'Alfredo Chicken Pasta',
  );
  final TextEditingController _stepsController = TextEditingController(
    text:
        '1. Boil the water and salt it.\n2. Drop the pasta and wait for 6.5 mins.\n3. ...',
  );

  String selectedCuisine = 'Italian';
  String selectedDuration = '~30 mins';
  String selectedDietType = 'None';

  List<Map<String, String>> ingredients = [
    {'name': 'Milk', 'unit': 'liters', 'quantity': '2'},
  ];

  void _addIngredient() {
    setState(() {
      ingredients.add({'name': '', 'unit': 'gram', 'quantity': '1'});
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void _showCustomPicker({
    required BuildContext context,
    required List<String> options,
    required String label,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                ...options.map(
                  (option) => ListTile(
                    title: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          color:
                              option == selectedValue
                                  ? Colors.orange
                                  : Colors.black,
                          fontWeight:
                              option == selectedValue
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelected(option);
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Center(
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  final commonInputDecoration = InputDecoration(
    labelText: 'Duration:',
    labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 14),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return TextStyle(
          color: Colors.green,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        );
      }

      return TextStyle(color: AppColors.textPrimary);
    }),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.textPrimary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.green, width: 2),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MealViewModel(),
      child: Consumer<MealViewModel>(
        builder: (context, mealViewModel, _) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Meal Management'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed:
                        mealViewModel.isLoading
                            ? null
                            : () async {
                              await mealViewModel.addMeal(
                                name: _mealNameController.text,
                                cuisine: selectedCuisine,
                                duration: selectedDuration,
                                calories: _caloriesController.text,
                                dietaryType: selectedDietType,
                                ingredients: ingredients,
                                steps: _stepsController.text,
                                imageFile: _selectedImage,
                              );

                              if (mealViewModel.errorMessage == null) {
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(mealViewModel.errorMessage!),
                                  ),
                                );
                              }
                            },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MealImagePicker(
                      selectedImage: _selectedImage,
                      onPickImage: _pickImage,
                    ),
                    SizedBox(height: context.hp(20)),
                    MealInfoFields(
                      mealNameController: _mealNameController,
                      selectedCuisine: selectedCuisine,
                      selectedDuration: selectedDuration,
                      selectedDietType: selectedDietType,
                      onCuisineChanged:
                          (value) => setState(() => selectedCuisine = value),
                      onDurationChanged:
                          (value) => setState(() => selectedDuration = value),
                      onDietTypeChanged:
                          (value) => setState(() => selectedDietType = value),
                      caloriesController: _caloriesController,
                    ),
                    SizedBox(height: context.hp(20)),
                    IngredientsList(
                      ingredients: ingredients,
                      onRemoveIngredient: _removeIngredient,
                      onUnitChanged: (index, val) {
                        setState(() {
                          ingredients[index]['unit'] = val;
                        });
                      },
                    ),
                    AddIngredientButton(onPressed: _addIngredient),
                    const SizedBox(height: 16),
                    StepsField(stepsController: _stepsController),
                    if (mealViewModel.isLoading)
                      Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
