/*   import 'package:flutter/material.dart';
  import 'package:meal_app/core/colors.dart';
  import 'package:meal_app/viewmodels/reminder_viewmodel.dart';
  import 'package:provider/provider.dart';

  class RemindersScreen extends StatefulWidget {
    const RemindersScreen({super.key});

    @override
    State<RemindersScreen> createState() => _RemindersScreenState();
  }

  class _RemindersScreenState extends State<RemindersScreen> {
    
  /*  @override
    void initState() {
      super.initState();
      Future.microtask(() =>
          context.read<ReminderViewModel>().fetchAndScheduleTodayReminders());
    } */

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (_) => ReminderViewModel(),
        child: Consumer<ReminderViewModel>(
          builder: (context, vm, _) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Reminders'),
                centerTitle: true,
              ),
              body: ValueListenableBuilder<int>(
                valueListenable: ReminderViewModel.reminderCount,
                builder: (context, count, _) {
                  if (count == 0) {
                    return const Center(
                      child: Text(
                        "You're all clear, there's no reminders!",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    final reminderVM = context.read<ReminderViewModel>();

                    return ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final task = reminders[index];
                        final firedTime = reminderVM.notificationTimes[task.id];
                        final displayTime = firedTime != null
                            ? TimeOfDay.fromDateTime(firedTime).format(context)
                            : "unknown";

                        return ListTile(
                          leading: const Icon(Icons.notifications_active),
                          title: Text(task.title),
                          subtitle: Text('Fired at $displayTime'),
                        );
                      },
                    );
                  }
                },
              ),
            );
          },
        ),
      );
    }
  }
 */

import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/task_model.dart';
import 'package:meal_app/viewmodels/reminder_viewmodel.dart';
import 'package:provider/provider.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReminderViewModel(),
      child: Consumer<ReminderViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Reminders'),
              centerTitle: true,
            ),
            body: ValueListenableBuilder<List<TaskModel>>(
              valueListenable: vm.todayReminders,
              builder: (context, reminderTasks, _) {
                if (reminderTasks.isEmpty) {
                  return const Center(
                    child: Text(
                      "You're all clear, there's no reminders!",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: reminderTasks.length,
                  itemBuilder: (context, index) {
                    final task = reminderTasks[index];
                    final firedTime = vm.notificationTimes[task.id];
                    final displayTime = firedTime != null
                        ? TimeOfDay.fromDateTime(firedTime).format(context)
                        : "unknown";

                    return ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title: Text(task.title),
                      subtitle: Text('Fired at $displayTime'),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
