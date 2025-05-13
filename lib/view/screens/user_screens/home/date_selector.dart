import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // Generate the next 7 days starting from today
    List<DateTime> next7Days = List.generate(7, (index) => today.add(Duration(days: index)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: next7Days.length,
        itemBuilder: (context, index) {
          final date = next7Days[index];
          final isToday = date.day == today.day &&
              date.month == today.month &&
              date.year == today.year;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: isToday ? Colors.green : Colors.black,
                  child: Text(
                    '${date.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('E').format(date), // Short day name like Mon, Tue
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? Colors.green : Colors.black,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
