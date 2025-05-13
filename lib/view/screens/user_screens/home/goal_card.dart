import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String progressText;
  final double progressValue;

  const GoalCard({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.progressText,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.white24,
            color: Colors.black,
          ),
          const SizedBox(height: 4),
          Text(
            progressText,
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.remove_circle_outline, color: Colors.black),
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.add_circle_outline, color: Colors.black),
              ),
            ],
          )
        ],
      ),
    );
  }
}
