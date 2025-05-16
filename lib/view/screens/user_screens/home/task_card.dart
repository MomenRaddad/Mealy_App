import 'package:flutter/material.dart';
import 'package:meal_app/view/screens/user_screens/home/dialogs/confirm_delete_dialog.dart';
import 'package:meal_app/view/screens/user_screens/home/dialogs/edit_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final String time;
  final String title;
  final bool isDone;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.time,
    required this.title,
    required this.isDone,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: isDone ? Colors.green : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
            color: isDone ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(time),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => EditTaskDialog(taskTitle: title),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ConfirmDeleteDialog(onConfirm: () {
                    if (onDelete != null) onDelete!();
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
