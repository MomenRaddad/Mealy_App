import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  final DateTime today = DateTime.now();
  late List<DateTime> next7Days;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    next7Days = List.generate(7, (i) => today.add(Duration(days: i - 3)));
    selectedIndex = 3;
  }

  bool _isToday(DateTime date) {
    return date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: next7Days.length,
        padding: const EdgeInsets.only(right: 6), // 👈 right-only for peek
        itemBuilder: (context, index) {
          final date = next7Days[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),

            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 6, 
                right: 6,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isSelected ? 64 : 42,
                    height: isSelected ? 64 : 42,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isToday(date) && !isSelected ? Colors.green : Colors.transparent,
                        width: 6,
                      ),
                    ),

                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSelected ? 22 : 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
