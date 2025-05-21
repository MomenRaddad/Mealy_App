// /*
//  * TODO: Refactor the page to use ChangeNotifier.
//  */
//
// import 'package:flutter/material.dart';
// import 'package:meal_app/core/colors.dart';
// import 'package:meal_app/utils/size_extensions.dart';
// import 'package:meal_app/view/components/search_bar.dart';
// import 'package:meal_app/view/screens/user_screens/home/date_selector.dart';
// import 'package:meal_app/view/screens/user_screens/home/goal_card.dart';
// import 'package:meal_app/view/screens/user_screens/home/header_section.dart';
// import 'package:meal_app/view/screens/user_screens/home/task_card.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, dynamic>> taskList = [
//     {"title": "Go to church", "time": "8:00 AM", "isDone": true},
//     {"title": "Breakfast with friends", "time": "10:00 AM", "isDone": true},
//     {"title": "Meeting", "time": "12:00 PM", "isDone": false},
//   ];
//
//   void deleteTask(int index) {
//     setState(() {
//       taskList.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int completedTasks = taskList.where((task) => task['isDone'] == true).length;
//     int totalTasks = taskList.length;
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const HeaderSection(),
//            /*  const SizedBox(height: 16),
//             SearchBarWidget(
//               hintText: "Search for tasks...",
//               onChanged: (query) {},
//             ),
//             */
//
//             SizedBox(height: context.hp(16)),
//
//             const DateSelector(),
//             SizedBox(height: context.hp(20)),
//
//              // Placeholder for "Your Goals" section
//             const Text(
//               'Your Goals',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//             ),
//
//             SizedBox(height: context.hp(10)),
//             SizedBox(height: context.hp(10)),
//
//             Row(
//               children: const [
//                 Expanded(
//                   child: GoalCard(
//                     backgroundColor: Colors.green,
//                     icon: Icons.directions_walk,
//                     title: 'Walk',
//                     currentValue: 420,
//                     goalValue: 6000,
//                     unit: 'Steps',
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: GoalCard(
//                     backgroundColor: AppColors.accent2,
//                     icon: Icons.opacity,
//                     title: 'Drink Water',
//                     currentValue: 2,
//                     goalValue: 5,
//                     unit: 'Cups',
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: context.hp(16)),
//             const GoalCard(
//               backgroundColor: AppColors.accent1,
//               icon: Icons.nightlight_round,
//               title: 'Sleep',
//               currentValue: 6,
//               goalValue: 8,
//               unit: 'Hours',
//             ),
//
//             SizedBox(height: context.hp(20)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Upcoming Tasks',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//                 ),
//                 Text(
//                   "$completedTasks / $totalTasks Tasks Completed",
//                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
//                 ),
//               ],
//             ),
//             SizedBox(height: context.hp(10)),
//
//             // Task List from state
//             Column(
//               children: List.generate(taskList.length, (index) {
//                 final task = taskList[index];
//                 return TaskCard(
//                   time: task['time'],
//                   title: task['title'],
//                   isDone: task['isDone'],
//                   onDelete: () => deleteTask(index),
//                 );
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
/*
 * TODO: Refactor the page to use ChangeNotifier.
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/components/search_bar.dart';
import 'package:meal_app/view/screens/user_screens/home/date_selector.dart';
import 'package:meal_app/view/screens/user_screens/home/goal_card.dart';
import 'package:meal_app/view/screens/user_screens/home/header_section.dart';
import 'package:meal_app/view/screens/user_screens/home/task_card.dart';
import 'package:meal_app/models/task_model.dart';
import 'package:meal_app/viewmodels/task_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            SizedBox(height: context.hp(16)),
            const DateSelector(),
            SizedBox(height: context.hp(20)),
            const Text(
              'Your Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: context.hp(10)),
            Row(
              children: const [
                Expanded(
                  child: GoalCard(
                    backgroundColor: Colors.green,
                    icon: Icons.directions_walk,
                    title: 'Walk',
                    currentValue: 420,
                    goalValue: 6000,
                    unit: 'Steps',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GoalCard(
                    backgroundColor: AppColors.accent2,
                    icon: Icons.opacity,
                    title: 'Drink Water',
                    currentValue: 2,
                    goalValue: 5,
                    unit: 'Cups',
                  ),
                ),
              ],
            ),
            SizedBox(height: context.hp(16)),
            const GoalCard(
              backgroundColor: AppColors.accent1,
              icon: Icons.nightlight_round,
              title: 'Sleep',
              currentValue: 6,
              goalValue: 8,
              unit: 'Hours',
            ),
            SizedBox(height: context.hp(20)),

            // Firebase Upcoming Tasks Section
            StreamBuilder<List<TaskModel>>(
              stream: TaskViewModel().getUserTasks(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text("Error loading tasks");
                }

                final tasks = snapshot.data ?? [];
                final completed = tasks.where((t) => t.status).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upcoming Tasks',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          "$completed / ${tasks.length} Tasks Completed",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    SizedBox(height: context.hp(10)),
                    if (tasks.isEmpty)
                      const Text("No tasks yet 😴")
                    else
                      Column(
                        children: tasks.map((task) {
                          final time = task.reminderEnabled && task.reminderTime != null
                              ? "${task.reminderTime!.hour}:${task.reminderTime!.minute.toString().padLeft(2, '0')}"
                              : "${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')}";

                          return TaskCard(
                            title: task.taskTitle,
                            time: time,
                            isDone: task.status,
                            onEdit: null,
                            onDelete: null,
                            onToggleDone: null,
                          );
                        }).toList(),
                      ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
