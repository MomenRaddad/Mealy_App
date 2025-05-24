import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('Drink Water Reminder'),
            subtitle: Text('Every 2 hours'),
          ),
          ListTile(
            leading: Icon(Icons.directions_walk),
            title: Text('Walk Reminder'),
            subtitle: Text('Daily at 5:00 PM'),
          ),
        ],
      ),
    );
  }
}
