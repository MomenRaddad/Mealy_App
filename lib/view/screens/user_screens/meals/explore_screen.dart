import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/view/components/search_bar.dart';
import 'package:meal_app/view/components/filter_chip_list.dart';
import 'package:meal_app/view/components/loading_widget.dart';
import 'package:meal_app/view/components/empty_state_widget.dart';
import 'package:meal_app/view/screens/user_screens/meals/explore_widgets/meal_card.dart';
import 'package:meal_app/core/strings.dart';
import 'package:meal_app/view/screens/user_screens/meals/explore_viewmodel.dart';
import 'package:meal_app/view/screens/user_screens/details/meal_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> filters = ["All", "Easy", "Simple", "Difficult", "Saif", "Spicy", "Amai"];
  String selectedFilter = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    Provider.of<ExploreViewModel>(context, listen: false).loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExploreViewModel>(context);
    final meals = viewModel.meals;

    List<Map<String, dynamic>> filteredMeals = meals.where((meal) {
      final matchesSearch = meal['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == "All" || meal['difficulty'] == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.exploreMealsTitle)),
      body: meals.isEmpty
          ? const Center(child: LoadingWidget(message: "Loading meals..."))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SearchBarWidget(
                  hintText: "Search meals...",
                  onChanged: (query) => setState(() => searchQuery = query),
                ),
                const SizedBox(height: 10),
                FilterChipList(
                  filters: filters,
                  initiallySelected: selectedFilter,
                  onSelected: (filter) => setState(() => selectedFilter = filter),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: filteredMeals.isEmpty
                      ? const EmptyStateWidget(
                          title: "No meals found!",
                          subtitle: "Try different filters or search query.",
                          icon: Icons.no_food,
                        )
                      : ListView.builder(
                          itemCount: filteredMeals.length,
                          itemBuilder: (context, index) {
                            final meal = filteredMeals[index];
                            return MealCard(
                              title: meal['title'],
                              imageUrl: meal['image'],
                              difficulty: meal['difficulty'],
                              duration: meal['duration'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MealDetailsScreen(mealId: meal['id']),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}