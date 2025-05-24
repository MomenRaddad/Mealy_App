import 'package:flutter/material.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/viewmodels/AdminMealsViewModel.dart';
import 'package:meal_app/view/screens/admin_screens/meals_management/meals_filter_bar.dart';
import 'package:meal_app/view/screens/admin_screens/meals_management/meals_list.dart';

class MealsManagementBody extends StatefulWidget {
  const MealsManagementBody({super.key});

  @override
  State<MealsManagementBody> createState() => _MealsManagementBodyState();
}

class _MealsManagementBodyState extends State<MealsManagementBody> {
  final List<String> filters = ["All", "Easy", "Simple", "Medium", "Difficult"];
  String selectedFilter = "all";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminMealsViewModel>(context);
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.meals.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.listenToMeals();
      });
      return const Center(
        child: Text('No meals available', style: TextStyle(fontSize: 18)),
      );
    }

    final filteredMeals =
        viewModel.meals.where((meal) {
          final matchesSearch = meal.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          final matchesFilter =
              selectedFilter == "all" ||
              meal.difficulty.name.toLowerCase() ==
                  selectedFilter.toLowerCase();

          return matchesSearch && matchesFilter;
        }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.hp(7),
          horizontal: context.wp(7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MealsFilterBar(
              filters: filters,
              selectedFilter: selectedFilter,
              searchQuery: searchQuery,
              onSearchChanged: (query) => setState(() => searchQuery = query),
              onFilterChanged:
                  (filter) =>
                      setState(() => selectedFilter = filter.toLowerCase()),
            ),

            MealsList(filteredMeals: filteredMeals),
          ],
        ),
      ),
    );
  }
}
