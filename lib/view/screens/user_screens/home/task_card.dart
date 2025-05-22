
import 'package:flutter/material.dart';

import 'dialogs/confirm_delete_dialog.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String category;
  final bool enableReminder;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.category,
    required this.enableReminder,
    this.onEdit,
    this.onDelete, required onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          enableReminder ? Icons.alarm_on : Icons.alarm_off,
          color: enableReminder ? Colors.blue : Colors.grey,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$category  •  $time"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmDeleteDialog(
                      onConfirm: onDelete!,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}