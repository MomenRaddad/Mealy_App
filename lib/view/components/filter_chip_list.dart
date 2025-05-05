import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';

class FilterChipList extends StatefulWidget {
  final List<String> filters;
  final Function(String) onSelected;
  final String? initiallySelected;

  const FilterChipList({
    super.key,
    required this.filters,
    required this.onSelected,
    this.initiallySelected,
  });

  @override
  State<FilterChipList> createState() => _FilterChipListState();
}

class _FilterChipListState extends State<FilterChipList> {
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: AppConstants.paddingMedium,
      ),
      child: Row(
        children:
            widget.filters.map((filter) {
              final bool isSelected = filter == selectedFilter;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ChoiceChip(
                  label: Text(filter),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.background,
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = filter;
                    });
                    widget.onSelected(filter);
                  },
                ),
              );
            }).toList(),
      ),
    );
  }
}
