import 'package:flutter/material.dart';
import 'dialogs/confirm_delete_dialog.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String category;
  final bool enableReminder;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDone;
  final ValueChanged<bool>? onToggleDone;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.category,
    required this.isDone,
    required this.enableReminder,
    this.onEdit,
    this.onDelete,
    this.onToggleDone,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      leading: IconButton(
        icon: Icon(
          isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: isDone ? Colors.green : Colors.grey,
        ),
        onPressed: () {
          if (onToggleDone != null) {
            onToggleDone!(!isDone);
          }
        },
    ),
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
          decorationThickness: 2,
          )),
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