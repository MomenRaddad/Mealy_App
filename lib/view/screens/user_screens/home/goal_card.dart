import 'package:flutter/material.dart';
import 'package:meal_app/utils/size_extensions.dart';
import 'package:meal_app/view/screens/user_screens/home/dialogs/edit_goal_dialog.dart';
import '../../../../core/colors.dart';

class GoalCard extends StatefulWidget {
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final int currentValue;
  final int goalValue;
  final String unit;

  const GoalCard({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.goalValue,
    required this.unit,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.currentValue;
  }

  void _increment() {
    setState(() {
      if (current < widget.goalValue) current++;
    });
  }

  void _decrement() {
    setState(() {
      if (current > 0) current--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = current / widget.goalValue;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => EditGoalDialog(goalTitle: widget.title),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + Title
            Row(
              children: [
                Icon(widget.icon, color: AppColors.textPrimary, size: 24),
                SizedBox(width: context.wp(8)),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.hp(12)),

            // Progress Text ABOVE the Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$current / ${widget.goalValue} ${widget.unit}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.hp(4)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.textSecondary.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.hp(12)),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.textPrimary,
                ),
                IconButton(
                  onPressed: _increment,
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
