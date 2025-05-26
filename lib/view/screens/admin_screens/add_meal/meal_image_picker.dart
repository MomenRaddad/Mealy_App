import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';

class MealImagePicker extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;
  final String? defaultAsset;
  final String? initialImageUrl;
  const MealImagePicker({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
    this.defaultAsset,
    this.initialImageUrl,
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
                  : (initialImageUrl != null && initialImageUrl!.isNotEmpty
                      ? Image.network(
                        initialImageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        defaultAsset ?? 'assets/images/images.png',
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
