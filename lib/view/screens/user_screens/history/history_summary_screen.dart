import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/viewmodels/visited_meals_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:meal_app/view/screens/user_screens/details/meal_details_screen.dart';

class HistorySummaryScreen extends StatefulWidget {
  const HistorySummaryScreen({super.key});

  @override
  State<HistorySummaryScreen> createState() => _HistorySummaryScreenState();
}

class _HistorySummaryScreenState extends State<HistorySummaryScreen> {
  final Set<String> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisitedMealsViewModel>(context, listen: false).fetchVisitedMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final visitedMeals = Provider.of<VisitedMealsViewModel>(context).visitedMeals;

    return Scaffold(
      appBar: AppBar(title: const Text("Visited Meals History")),
      body: visitedMeals.isEmpty
          ? const Center(child: Text("No meals visited yet."))
          : ListView.builder(
              itemCount: visitedMeals.length,
              itemBuilder: (context, index) {
                final meal = visitedMeals[index];
                final isFav = favoriteIds.contains(meal.id);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailsScreen(mealId: meal.id),
                        ),
                      );
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: meal.image.isNotEmpty
                          ? Image.network(meal.image, width: 60, height: 60, fit: BoxFit.cover)
                          : const Icon(Icons.fastfood),
                    ),
                    title: Text(
                      meal.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(DateFormat.yMMMEd().add_jm().format(meal.visitedAt)),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFav) {
                            favoriteIds.remove(meal.id);
                          } else {
                            favoriteIds.add(meal.id);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
