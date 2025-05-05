import 'package:flutter/material.dart';

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
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.27,
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
              const SizedBox(width: 4),
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
          const SizedBox(height: 4),
          Container(height: 2, width: double.infinity, color: Colors.black45),
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
