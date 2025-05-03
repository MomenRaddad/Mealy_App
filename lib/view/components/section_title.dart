import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;

  const SectionTitle({
    Key? key,
    required this.text,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: AppConstants.paddingMedium,
            horizontal: AppConstants.paddingMedium,
          ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: AppConstants.fontLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
/**How to use ?!  */

/*

SectionTitle(text: "Explore Meals"),

SectionTitle(
  text: "Recommended Recipes",
  padding: const EdgeInsets.only(left: 24, top: 16),
)



*/