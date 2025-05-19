import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/view/screens/user_screens/details/meal_details_viewmodel.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/core/constants.dart';
import 'package:meal_app/view/components/pill_label.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  const MealDetailsScreen({super.key, required this.mealId});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MealDetailsViewModel>(context, listen: false)
        .loadMealById(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MealDetailsViewModel>(context);
    final meal = viewModel.meal;

    if (viewModel.isLoading || meal == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ Safe null-handling
    final String image = meal['image'] as String? ?? '';
    final String title = meal['name'] as String? ?? 'Untitled Meal';
    final String duration = meal['duration'] as String? ?? 'Unknown';
    final String difficulty = meal['dietaryType'] as String? ?? 'Unknown';
    final List<dynamic> ingredients = meal['ingredients'] ?? [];
    final List<dynamic> steps = meal['steps'] ?? [];

    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background image or placeholder
          Hero(
            tag: title,
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 80),
                  )
                : const Placeholder(fallbackHeight: 200),
          ),

          // ✅ Scrollable content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.45,
              bottom: 20,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Title and Favorite icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: () {
                          setState(() => isFavorite = !isFavorite);
                          // TODO: add logic for saving to favorites
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ✅ Info labels
                  Row(
                    children: [
                      PillLabel(text: difficulty),
                      const SizedBox(width: 8),
                      PillLabel(
                        text: duration,
                        backgroundColor: AppColors.accent2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ✅ Ingredients section
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...ingredients.map((item) {
                    if (item is String) return Text("• $item");
                    if (item is Map) {
                      final name = item['name'] ?? '';
                      final qty = item['quantity'] ?? '';
                      final unit = item['unit'] ?? '';
                      return Text("• $qty $unit $name");
                    }
                    return const SizedBox.shrink();
                  }).toList(),

                  const SizedBox(height: 24),

                  // ✅ Steps section
                  const Text(
                    "Method of Preparation",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...steps.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final step = entry.value ?? '';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("$index. $step"),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // ✅ Back button
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
