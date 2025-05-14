import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/viewmodels/add_meal_viewmodel.dart';
import 'package:meal_app/models/meal_model.dart';

import 'meal_image_picker.dart';
import 'meal_info_fields.dart';
import 'ingredients_list.dart';
import 'add_ingredient_button.dart';
import 'steps_field.dart';

// This is the page for adding a meal
class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  bool _imageError = false;

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageError = false;
      });
    }
  }

  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  String selectedCuisine = 'Italian';
  String selectedDuration = 'min30to60';
  String selectedDietType = 'Regular';

  List<Map<String, String>> ingredients = [
    {'name': 'Milk', 'unit': 'liters', 'quantity': '2'},
  ];

  void _addIngredient() {
    setState(() {
      ingredients.add({'name': '', 'unit': 'grams', 'quantity': '1'});
    });
  }

  void _removeIngredient(int index) {
    if (ingredients.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one ingredient is required')),
      );
      return;
    }
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
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children:
                          options
                              .map(
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
                              )
                              .toList(),
                    ),
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
      create: (_) => AddMealViewModel(),
      child: Consumer<AddMealViewModel>(
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
                              bool valid =
                                  _formKey.currentState?.validate() ?? false;
                              bool ingredientsValid = true;
                              for (var ing in ingredients) {
                                if ((ing['name']?.trim().isEmpty ?? true) ||
                                    (ing['quantity']?.trim().isEmpty ?? true) ||
                                    (ing['unit']?.trim().isEmpty ?? true)) {
                                  ingredientsValid = false;
                                  break;
                                }
                              }
                              if (!valid || !ingredientsValid) {
                                setState(() {
                                  _imageError = _selectedImage == null;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill all required fields',
                                    ),
                                  ),
                                );
                                return;
                              }
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show image picker
                      MealImagePicker(
                        selectedImage: _selectedImage,
                        onPickImage: _pickImage,
                        defaultAsset: 'assets/images/default_meal.jpg',
                      ),
                      SizedBox(height: 20),
                      // Meal info fields
                      MealInfoFields(
                        mealNameController: _mealNameController,
                        caloriesController: _caloriesController,
                        selectedCuisine: selectedCuisine,
                        selectedDuration: selectedDuration,
                        selectedDietType: selectedDietType,
                        onCuisineChanged:
                            (val) => setState(() => selectedCuisine = val),
                        onDurationChanged:
                            (val) => setState(() => selectedDuration = val),
                        onDietTypeChanged:
                            (val) => setState(() => selectedDietType = val),
                        nameValidator:
                            (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                        caloriesValidator:
                            (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 20),
                      // Ingredients list
                      IngredientsList(
                        ingredients: ingredients,
                        onRemoveIngredient: _removeIngredient,
                        onUnitChanged: (index, val) {
                          setState(() {
                            ingredients[index]['unit'] = val;
                          });
                        },
                        showError: false,
                      ),
                      AddIngredientButton(onPressed: _addIngredient),
                      const SizedBox(height: 16),
                      // Steps field
                      StepsField(
                        stepsController: _stepsController,
                        stepsValidator:
                            (val) =>
                                (val == null || val.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                        hintText:
                            'Enter the steps for preparing the meal, e.g.\n1. Boil the water and salt it.\n2. Drop the pasta and wait for 6.5 mins.\n3. ...',
                      ),
                      if (mealViewModel.isLoading)
                        Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
