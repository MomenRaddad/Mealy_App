import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';

class PillLabel extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  const PillLabel({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.accent2,
    this.textColor = AppColors.textPrimary,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.fontSize = AppConstants.fontSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
