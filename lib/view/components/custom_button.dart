import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final double elevation;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.radius = AppConstants.radiusMedium,
    this.elevation = AppConstants.buttonElevation,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 20,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppConstants.fontMedium,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
/** How To USE ? */ 
/*
CustomButton(
  text: "View Recipe",
  onPressed: () {
   
  },
)
*/