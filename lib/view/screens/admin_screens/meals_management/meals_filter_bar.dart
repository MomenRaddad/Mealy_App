import 'package:flutter/material.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/components/search_bar.dart';
import 'package:meal_app/view/components/filter_chip_list.dart';

class MealsFilterBar extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;

  const MealsFilterBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(
          hintText: "Search meals...",
          onChanged: onSearchChanged,
        ),
        SizedBox(height: context.hp(3)),
        FilterChipList(
          filters: filters,
          initiallySelected: "All",
          onSelected: onFilterChanged,
        ),
      ],
    );
  }
}
