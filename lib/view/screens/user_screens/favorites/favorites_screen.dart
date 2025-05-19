import 'package:flutter/material.dart';
import 'package:meal_app/viewmodels/favorites_viewmodel.dart';
import 'package:provider/provider.dart';
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
  final String dummyUserId = "sLknwnNPPa0eXns5zVAB"; // Replace with your actual dummy user ID

  @override
  Widget build(BuildContext context) {
    debugPrint("FavoritesScreen userId: $dummyUserId")
    ;
    return ChangeNotifierProvider<FavoritesViewModel>(
      create: (_) => FavoritesViewModel()..fetchFavoriteMeals(dummyUserId),
      builder: (context, child) {
        final viewModel = Provider.of<FavoritesViewModel>(context);
        final groupedMeals = viewModel.groupedFavorites;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              const FavoritesHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<SortOption>(
                      value: viewModel.currentSort,
                      elevation: 4,
                      underline: Container(),
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Colors.white,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      icon: const Icon(Icons.sort, color: Colors.black),
                      onChanged: (SortOption? newValue) {
                        if (newValue != null) {
                          viewModel.setSortOption(newValue);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: SortOption.dateDescending,
                          child: Text("Date: Newest First"),
                        ),
                        DropdownMenuItem(
                          value: SortOption.dateAscending,
                          child: Text("Date: Oldest First"),
                        ),
                        DropdownMenuItem(
                          value: SortOption.titleAZ,
                          child: Text("Title: A → Z"),
                        ),
                        DropdownMenuItem(
                          value: SortOption.titleZA,
                          child: Text("Title: Z → A"),
                        ),
                        DropdownMenuItem(
                          value: SortOption.durationShortLong,
                          child: Text("Duration: Short → Long"),
                        ),
                        DropdownMenuItem(
                          value: SortOption.durationLongShort,
                          child: Text("Duration: Long → Short"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.meals.isEmpty
                        ? const Center(child: Text("No favorite meals yet."))
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: groupedMeals.entries.map((entry) {
                              final date = entry.key;
                              final meals = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          date,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...meals.asMap().entries.map((e) {
                                    final index = e.key;
                                    final meal = e.value;

                                    return Dismissible(
                                      key: ValueKey(meal.id + date),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        bool confirmed = false;

                                        await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => ConfirmDeleteDialog(
                                            onConfirm: () {
                                              confirmed = true;

                                              Provider.of<FavoritesViewModel>(
                                                context,
                                                listen: false,
                                              ).removeFavoriteMealFromUser(dummyUserId, meal.id);

                                              //Navigator.of(context).pop();
                                            },
                                          ),
                                        );

                                        return confirmed;
                                      },
                                      onDismissed: (_) {
                                        final viewModel = Provider.of<FavoritesViewModel>(context, listen: false);
                                        viewModel.removeFavoriteMealFromUser(dummyUserId, meal.id);
                                      },
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade400,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      child: MealCard(
                                        title: meal.title,
                                        imageUrl: meal.imageUrl,
                                        duration: meal.duration,
                                        difficulty: meal.difficulty,
                                        onTap: () {
                                          debugPrint("Tapped on ${meal.title}");
                                          // TODO: Navigate to MealDetailsScreen
                                        },
                                      ),
                                    );
                                  }).toList()
                                ],
                              );
                            }).toList(),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
