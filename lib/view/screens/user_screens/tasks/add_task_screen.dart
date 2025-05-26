
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:meal_app/models/task_model.dart';
import 'package:meal_app/viewmodels/task_viewmodel.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime? _taskTime;
  bool _enableReminder = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),backgroundColor: Colors.red,),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _taskTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    final category = _categoryController.text.trim();

    if (title.isEmpty || category.isEmpty || _taskTime == null) {
      _showSnackbar("All fields are required");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackbar("You are not logged in");
      return;
    }

    final task = TaskModel(
      id: '',
      title: title,
      taskCategory: category,
      taskTime: _taskTime!,
      enableReminder: _enableReminder,
      isCompleted: false,
    );

    try {
      await TaskViewModel().addTask(user.uid, task);
      if (!mounted) return;
      Navigator.pop(context, 'refresh');
    } catch (e) {
      _showSnackbar("Failed to save task");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDateTime = _taskTime != null
        ? DateFormat('yyyy-MM-dd • HH:mm').format(_taskTime!)
        : 'No Date & Time selected';

    return Scaffold(
      appBar: AppBar(title: const Text("Add Task"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_titleController, "Title"),
            const SizedBox(height: 16),
            _buildTextField(_categoryController, "Category"),
            const SizedBox(height: 16),
            _buildDateTimePicker(formattedDateTime),
            const SizedBox(height: 16),
            _buildReminderCheckbox(),
            const Spacer(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDateTimePicker(String label) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        ElevatedButton(
          onPressed: _pickDateTime,
          child: const Text("Pick Date & Time"),
        ),
      ],
    );
  }

  Widget _buildReminderCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _enableReminder,
          onChanged: (value) =>
              setState(() => _enableReminder = value ?? false),
        ),
        const Text("Enable Reminder"),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTask,

        child: const Text("Save Task"),
      ),
    );
  }
}


