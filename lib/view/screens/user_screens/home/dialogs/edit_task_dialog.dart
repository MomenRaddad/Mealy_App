import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';

class EditTaskDialog extends StatelessWidget {
  final String taskTitle;

  const EditTaskDialog({super.key, required this.taskTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Edit Task: $taskTitle',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: TextField(
        decoration: const InputDecoration(
          labelText: 'Task Title',
          hintText: 'e.g., Grocery shopping',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Add logic later
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
