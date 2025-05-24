import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(); // Run your delete logic
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
