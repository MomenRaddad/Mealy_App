import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';

class AddIngredientButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddIngredientButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.add_circle,
          color: AppColors.textPrimary,
          size: context.hp(20),
        ),
        label: Text(
          'Add Ingredient',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.hp(12),
            color: AppColors.textPrimary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.hp(24)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.wp(14),
            vertical: context.hp(8),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
