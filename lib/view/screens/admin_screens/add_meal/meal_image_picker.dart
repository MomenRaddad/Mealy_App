import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';

class MealImagePicker extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;
  final String? defaultAsset;
  const MealImagePicker({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
    this.defaultAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child:
              selectedImage != null
                  ? Image.file(
                    selectedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                  : (defaultAsset != null
                      ? Image.asset(
                        defaultAsset!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Image.network(
                        'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: InkWell(
            onTap: onPickImage,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Text(
                    "Edit Picture",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: context.wp(4)),
                  Icon(Icons.edit, color: AppColors.textPrimary, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
