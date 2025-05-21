// import 'package:flutter/material.dart';
// import 'package:meal_app/viewmodels/task_viewmodel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:meal_app/models/task_model.dart';
//
// class AddTaskScreen extends StatefulWidget {
//   final TaskModel? taskToEdit;
//
//   const AddTaskScreen({super.key, this.taskToEdit});
//
//   @override
//   State<AddTaskScreen> createState() => _AddTaskScreenState();
// }
//
// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final TextEditingController _taskNameController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//
//   DateTime? _selectedDate;
//   TimeOfDay? _reminderTime;
//   bool _enableReminder = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.taskToEdit != null) {
//       final task = widget.taskToEdit!;
//       _taskNameController.text = task.taskTitle;
//       _categoryController.text = task.categoryName;
//       _selectedDate = task.dueDate;
//       _enableReminder = task.reminderEnabled;
//       if (task.reminderTime != null) {
//         _reminderTime = TimeOfDay.fromDateTime(task.reminderTime!);
//       }
//     }
//   }
//
//   Future<void> _pickDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//       initialDate: _selectedDate ?? DateTime.now(),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }
//
//   Future<void> _pickTime() async {
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _reminderTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _reminderTime = pickedTime;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.taskToEdit != null;
//
//     return Scaffold(
//       appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'Create Task')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _taskNameController,
//               decoration: const InputDecoration(labelText: 'Task Name'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _categoryController,
//               decoration: const InputDecoration(labelText: 'Custom Category'),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     _selectedDate == null
//                         ? 'No date selected'
//                         : 'Selected Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _pickDate,
//                   child: const Text('Pick Date'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Checkbox(
//                   value: _enableReminder,
//                   onChanged: (value) {
//                     setState(() {
//                       _enableReminder = value!;
//                       if (!_enableReminder) _reminderTime = null;
//                     });
//                   },
//                 ),
//                 const Text("Enable Reminder"),
//               ],
//             ),
//             if (_enableReminder) ...[
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       _reminderTime == null
//                           ? 'No time selected'
//                           : 'Reminder at: ${_reminderTime!.format(context)}',
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: _pickTime,
//                     child: const Text('Pick Time'),
//                   ),
//                 ],
//               ),
//             ],
//             const Spacer(),
//             ElevatedButton(
//               onPressed: () async {
//                 final user = FirebaseAuth.instance.currentUser;
//                 if (user == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('User not logged in')),
//                   );
//                   return;
//                 }
//
//                 final taskVM = TaskViewModel();
//
//                 if (isEdit) {
//                   await taskVM.updateTask(
//                     userId: user.uid,
//                     taskId: widget.taskToEdit!.taskId,
//                     taskTitle: _taskNameController.text,
//                     categoryName: _categoryController.text,
//                     dueDate: _selectedDate!,
//                     reminderEnabled: _enableReminder,
//                     reminderTime: _reminderTime != null
//                         ? DateTime(
//                       _selectedDate!.year,
//                       _selectedDate!.month,
//                       _selectedDate!.day,
//                       _reminderTime!.hour,
//                       _reminderTime!.minute,
//                     )
//                         : null,
//                     status: widget.taskToEdit!.status,
//                   );
//                 } else {
//                   await taskVM.addTask(
//                     userId: user.uid,
//                     name: _taskNameController.text,
//                     category: _categoryController.text,
//                     date: _selectedDate ?? DateTime.now(),
//                     reminderTime: _reminderTime,
//                     enableReminder: _enableReminder,
//                   );
//                 }
//
//                 Navigator.pop(context);
//               },
//               child: Text(isEdit ? 'Update Task' : 'Save Task'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
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
      SnackBar(content: Text(message)),
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
    );

    try {
      await TaskViewModel().addTask(user.uid, task);
      if (!mounted) return;
      Navigator.pop(context);
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
      appBar: AppBar(title: const Text("Add Task")),
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


