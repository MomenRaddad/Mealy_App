import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/view/screens/user_screens/home/dialogs/confirm_delete_dialog.dart';
import 'package:meal_app/view/screens/user_screens/meals/explore_widgets/meal_card.dart';
import 'package:meal_app/view/screens/user_screens/favorites/favorites_header.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteMeals = [
    {
      "title": "Chicken Alfredo",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5EuVYEm22v_-iy2vFQ-4niAT7Dk4uzs_CYA&s",
      "difficulty": "Easy",
      "duration": "30 min",
    },
    {
      "title": "Grilled Salmon",
      "imageUrl":
          "https://images.unsplash.com/photo-1604908177529-29349c362a68",
      "difficulty": "Medium",
      "duration": "10 min",
    },
  ];

  void deleteFavorite(int index) {
    setState(() {
      favoriteMeals.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const FavoritesHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                final meal = favoriteMeals[index];
                return Dismissible(
                  key: ValueKey(meal['title'] + index.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => ConfirmDeleteDialog(
                            onConfirm: () {
                              deleteFavorite(index);
                              //Navigator.of(ctx, rootNavigator: true).pop(true);
                            },
                          ),
                        ) ??
                        false;
                    return confirmed;
                  },
                  onDismissed: (_) => deleteFavorite(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: MealCard(
                    title: meal['title'],
                    imageUrl: meal['imageUrl'],
                    duration: meal['duration'],
                    difficulty: meal['difficulty'],
                    onTap: () {
                      debugPrint("Tapped on ${meal['title']}");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
