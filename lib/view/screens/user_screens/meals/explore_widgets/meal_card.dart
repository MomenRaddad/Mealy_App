import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/core/constants.dart';
import 'package:meal_app/view/components/custom_button.dart';
import 'package:meal_app/view/components/pill_label.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String difficulty;
  final String duration;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.difficulty,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusLarge),
            ),
            child: imageUrl.startsWith('http')
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

               
                Row(
                  children: [
                    PillLabel(text: difficulty),
                    const SizedBox(width: 8),
                    PillLabel(
                      text: duration,
                      backgroundColor: AppColors.accent2,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "View Recipe",
                    onPressed: onTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
