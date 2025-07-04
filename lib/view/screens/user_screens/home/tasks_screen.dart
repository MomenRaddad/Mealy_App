import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_app/viewmodels/task_viewmodel.dart';
import 'package:meal_app/models/task_model.dart';
import 'package:meal_app/view/screens/user_screens/home/task_card.dart';
import '../tasks/edit_task_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("User not logged in"));
    }

    return StreamBuilder<List<TaskModel>>(
      stream: TaskViewModel().getUserTasks(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text("Error loading tasks");
        }

        final tasks = snapshot.data ?? [];
        final completed = tasks.where((t) => t.isCompleted).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Upcoming Tasks",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("$completed / ${tasks.length} Tasks"),
              ],
            ),
            const SizedBox(height: 10),
            if (tasks.isEmpty)
              const Text("No tasks yet ")
            else
              ...tasks.map((task) {
                final formattedTime =
                    "${task.taskTime.hour}:${task.taskTime.minute.toString().padLeft(2, '0')}";

                return TaskCard(
                  title: task.title,
                  time: formattedTime,
                  category: task.taskCategory,
                  isDone: task.isCompleted,
                  enableReminder: task.enableReminder,

                  onDelete: () => TaskViewModel().deleteTask(user.uid, task.id),
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTaskScreen(task: task),
                      ),
                    );
                  }, onToggleDone: (val) {
                  debugPrint("Task ${task.id} toggled to ${val ? 'done' : 'not done'}");
                  TaskViewModel().updateTask(
                    user.uid,
                    task.copyWith(isCompleted: val),
                  );
                },
                );
              }).toList(),
          ],
        );
      },
    );
  }
}

