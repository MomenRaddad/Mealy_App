import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:meal_app/models/task_model.dart';
import 'package:meal_app/viewmodels/task_viewmodel.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late DateTime _taskTime;
  late bool _enableReminder;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _categoryController = TextEditingController(text: widget.task.taskCategory);
    _taskTime = widget.task.taskTime;
    _enableReminder = widget.task.enableReminder;
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _taskTime,
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_taskTime),
    );

    if (time == null) return;

    setState(() {
      _taskTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: Colors.red,));
  }

  Future<void> _updateTask() async {
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

    final updatedTask = TaskModel(
      id: widget.task.id,
      title: title,
      taskCategory: category,
      taskTime: _taskTime,
      enableReminder: _enableReminder,
    );

    try {
      await TaskViewModel().updateTask(user.uid, updatedTask);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      _showSnackbar("Failed to update task");
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('yyyy-MM-dd • HH:mm').format(_taskTime);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_titleController, "Title"),
            const SizedBox(height: 16),
            _buildTextField(_categoryController, "Category"),
            const SizedBox(height: 16),
            _buildDateTimePicker(formatted),
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
          onChanged: (value) => setState(() => _enableReminder = value ?? false),
        ),
        const Text("Enable Reminder"),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _updateTask,
        child: const Text("Update Task"),
      ),
    );
  }
}
