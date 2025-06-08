
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/user_screens/home/date_selector.dart';
import 'package:meal_app/view/screens/user_screens/home/goal_card.dart';
import 'package:meal_app/view/screens/user_screens/home/header_section.dart';
import 'package:meal_app/view/screens/user_screens/home/tasks_screen.dart';
import 'package:meal_app/viewmodels/reminder_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ReminderViewModel>().fetchAndScheduleTodayReminders());
  }

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
                const TasksScreen(),
              ],
            ),
          ),
        );
      }    
    
  }
