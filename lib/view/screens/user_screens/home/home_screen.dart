import 'package:flutter/material.dart';
import 'package:meal_app/view/screens/user_screens/home/goal_card.dart';
import 'package:meal_app/view/screens/user_screens/home/header_section.dart';
import 'package:meal_app/view/screens/user_screens/home/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
              const HeaderSection(),
              const SizedBox(height: 16),

            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date selector
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final List<String> days = ['Thur', 'Fri', 'Sat', 'Sun', 'Mon', 'Tues', 'Wed'];
                  final List<int> dates = [5, 6, 7, 8, 9, 10, 11];
                  final bool isToday = index == 3;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: isToday ? Colors.green : Colors.black,
                          child: Text(
                            '${dates[index]}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          days[index],
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
            ),

            const SizedBox(height: 20),

            // Placeholder for "Your Goals" section
            const Text(
              'Your Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const SizedBox(height: 10),

            GoalCard(
              backgroundColor: Colors.green,
              icon: Icons.directions_walk,
              title: 'Walk',
              progressText: '450 / 6000 Steps',
              progressValue: 0.075,
            ),
            GoalCard(
              backgroundColor: Colors.amber,
              icon: Icons.opacity,
              title: 'Drink Water',
              progressText: '2 / 5 Cups',
              progressValue: 0.4,
            ),
            GoalCard(
              backgroundColor: Colors.deepOrange,
              icon: Icons.nightlight_round,
              title: 'Sleep',
              progressText: '6 / 8 Hours',
              progressValue: 0.75,
            ),

            // Placeholder for "Upcoming tasks" section
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: null, // TODO: add task action
                  icon: Icon(Icons.add),
                  label: Text('New Task'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Example tasks
            TaskCard(
              time: '8:00 AM',
              title: 'Go to church',
              isDone: true,
            ),
            TaskCard(
              time: '10:00 AM',
              title: 'Breakfast with friends',
              isDone: true,
            ),
            TaskCard(
              time: '12:00 PM',
              title: 'Meeting',
              isDone: false,
            ),

          ],
        ),
      ),

      
    );
  }
}