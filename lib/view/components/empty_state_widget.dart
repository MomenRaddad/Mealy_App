import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double iconSize;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox, 
    this.iconSize = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: AppColors.textSecondary),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppConstants.fontLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
