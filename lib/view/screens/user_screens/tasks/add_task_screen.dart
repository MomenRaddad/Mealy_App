import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String _selectedRepeat = 'None';
  TimeOfDay? _reminderTime;

  final List<String> _repeatOptions = ['None', 'Daily', 'Weekly', 'Monthly'];

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Custom Category'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _selectedRepeat,
              items: _repeatOptions
                  .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedRepeat = val!;
                });
              },
              decoration: const InputDecoration(labelText: 'Repeat Schedule'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _reminderTime == null
                        ? 'No reminder time set'
                        : 'Reminder at: ${_reminderTime!.format(context)}',
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickTime,
                  child: const Text('Pick Time'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Save to Firebase
                print('Task: ${_taskNameController.text}');
              },
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
