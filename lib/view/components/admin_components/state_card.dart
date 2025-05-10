import 'package:flutter/material.dart';
import 'package:meal_app/utils/size_extensions.dart';

class StatCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String count;

  const StatCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.wp(110),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87),
              SizedBox(width: context.wp(4)),
              Expanded(
                child: Text(
                  label,
                  // textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.hp(4)),
          Container(
            height: context.hp(2),
            width: double.infinity,
            color: Colors.black45,
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              textAlign: TextAlign.center,

              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
