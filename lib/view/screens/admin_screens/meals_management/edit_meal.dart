import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/add_ingredient_button.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/ingredients_list.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/meal_image_picker.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/meal_info_fields.dart';
import 'package:meal_app/view/screens/admin_screens/add_meal/steps_field.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/viewmodels/edit_meal_viewmodel.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/network_utils.dart';
import 'package:meal_app/utils/size_extensions.dart';

class EditMealScreen extends StatefulWidget {
  final MealModel meal;

  const EditMealScreen({super.key, required this.meal});

  @override
  State<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mealNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _stepsController = TextEditingController();

  File? _selectedImage;
  late CuisineType selectedCuisine;
  late DurationType selectedDuration;
  late DietaryType selectedDietType;
  late MealDifficulty selectedDifficulty;
  late List<Map<String, String>> ingredients;

  @override
  void initState() {
    super.initState();
    final meal = widget.meal;
    _mealNameController.text = meal.name;
    _caloriesController.text = meal.calories.toString();
    _stepsController.text = meal.steps;
    selectedCuisine = meal.cuisine;
    selectedDuration = meal.duration;
    selectedDietType = meal.dietaryType;
    selectedDifficulty = meal.difficulty;

    ingredients =
        meal.ingredients
            .map(
              (ing) => {
                'name': ing.name,
                'quantity': ing.quantity,
                'unit': ing.unit.toString().split('.').last,
              },
            )
            .toList();
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _addIngredient() {
    setState(() => ingredients.add({'name': '', 'unit': 'g', 'quantity': '1'}));
  }

  void _removeIngredient(int index) {
    if (ingredients.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one ingredient is required')),
      );
      return;
    }
    setState(() => ingredients.removeAt(index));
  }

  Future<void> _handleSave(EditMealViewModel viewModel) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    bool ingredientsValid = ingredients.every(
      (ing) =>
          ing['name']!.trim().isNotEmpty &&
          ing['quantity']!.trim().isNotEmpty &&
          ing['unit']!.trim().isNotEmpty,
    );

    if (!ingredientsValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all ingredient fields')),
      );
      return;
    }

    await viewModel.updateMeal(
      meal: widget.meal,
      name: _mealNameController.text,
      cuisine: selectedCuisine.toString().split('.').last,
      duration: selectedDuration.toString().split('.').last,
      calories: _caloriesController.text,
      dietaryType: selectedDietType.toString().split('.').last,
      ingredients: ingredients,
      steps: _stepsController.text,
      imageFile: _selectedImage,
      difficulty: selectedDifficulty.toString().split('.').last,
    );

    if (viewModel.errorMessage == null) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(viewModel.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditMealViewModel(),
      child: Consumer<EditMealViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Edit Meal'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    final isConnected =
                        await NetworkUtils.checkInternetAndShowDialog(context);
                    if (!isConnected) return;
                    if (!viewModel.isLoading) {
                      await _handleSave(viewModel);
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
                  children: [
                    MealImagePicker(
                      selectedImage: _selectedImage,
                      onPickImage: _pickImage,
                      defaultAsset: 'assets/images/default_meal.jpg',
                      initialImageUrl: widget.meal.photoUrl,
                    ),
                    const SizedBox(height: 20),
                    MealInfoFields(
                      mealNameController: _mealNameController,
                      caloriesController: _caloriesController,
                      selectedCuisine: selectedCuisine,
                      selectedDuration: selectedDuration,
                      selectedDietType: selectedDietType,
                      selectedDifficulty: selectedDifficulty,
                      onDifficultyChanged:
                          (val) => setState(() => selectedDifficulty = val),
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
                    SizedBox(height: context.hp(20)),
                    IngredientsList(
                      ingredients: ingredients,
                      onRemoveIngredient: _removeIngredient,
                      onUnitChanged:
                          (index, val) =>
                              setState(() => ingredients[index]['unit'] = val),
                      showError: false,
                    ),
                    AddIngredientButton(onPressed: _addIngredient),
                    SizedBox(height: context.hp(16)),
                    StepsField(
                      stepsController: _stepsController,
                      stepsValidator:
                          (val) =>
                              val == null || val.trim().isEmpty
                                  ? 'Required'
                                  : null,
                      hintText: 'Enter the steps for preparing the meal...',
                    ),
                    if (viewModel.isLoading)
                      const Center(child: CircularProgressIndicator()),
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
