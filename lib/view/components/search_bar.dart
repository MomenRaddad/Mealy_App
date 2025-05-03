import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    Key? key,
    required this.onChanged,
    this.hintText = "Search...",
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
/**How To USE ?  0*/

/*
SearchBarWidget(
  hintText: "Search for meals...",
  onChanged: (query) {
    print(); 
  },
)
*/