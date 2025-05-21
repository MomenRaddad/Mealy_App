// ✅ UPDATED MealDetailsScreen with proper ingredient + step parsing
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'meal_details_viewmodel.dart';
import 'package:meal_app/view/components/pill_label.dart';
import 'package:meal_app/core/colors.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  const MealDetailsScreen({super.key, required this.mealId});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealDetailsViewModel>(context, listen: false)
          .loadMealById(widget.mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MealDetailsViewModel>(context);

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final meal = vm.meal!;
    final image = meal['photoUrl'] ?? '';
    final title = meal['name'] ?? 'No Title';
    final duration = meal['duration'] ?? '';
    final difficulty = meal['difficulty'] ?? '';

    // ✅ Safe ingredient extraction
    final ingredientsRaw = meal['ingredients'];
    final List<Map<String, dynamic>> ingredients = ingredientsRaw is List
        ? ingredientsRaw.cast<Map<String, dynamic>>()
        : [];

    // ✅ Safe step extraction
    final stepsRaw = meal['steps'];
    final List<String> steps = stepsRaw is List
        ? stepsRaw.cast<String>()
        : stepsRaw.toString().split('.');

    return Scaffold(
      body: Stack(
        children: [
          image.isNotEmpty
              ? Image.network(
                  image,
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Placeholder(fallbackHeight: 300),

          SingleChildScrollView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Favorite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      PillLabel(text: difficulty),
                      const SizedBox(width: 8),
                      PillLabel(text: duration, backgroundColor: AppColors.accent2),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Ingredients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...ingredients.map((i) => Text("• ${i['quantity']} ${i['unit']} of ${i['name']}")),

                  const SizedBox(height: 24),
                  const Text("Preparation Steps", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...steps.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text("${entry.key + 1}. ${entry.value.trim()}"),
                      )),

                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final vm = Provider.of<MealDetailsViewModel>(context, listen: false);
                      await vm.markMealAsDone(widget.mealId, title, image);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meal marked as done!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Done"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}