
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:meal_app/models/task_model.dart';
//
// class TaskViewModel {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> addTask({
//     required String userId,
//     required String name,
//     required String category,
//     required DateTime date,
//     TimeOfDay? reminderTime,
//     bool enableReminder = false,
//   }) async {
//     try {
//       final taskData = {
//         'taskTitle': name,
//         'categoryName': category,
//         'dueDate': date.toIso8601String(),
//         'reminderEnabled': enableReminder,
//         'reminderTime': enableReminder && reminderTime != null
//             ? DateTime(
//           date.year,
//           date.month,
//           date.day,
//           reminderTime.hour,
//           reminderTime.minute,
//         ).toIso8601String()
//             : null,
//         'status': false,
//         'createdAt': DateTime.now().toIso8601String(),
//       };
//
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('tasks')
//           .add(taskData);
//     } catch (e) {
//       print(' Failed to add task: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> updateTask({
//     required String userId,
//     required String taskId,
//     required String taskTitle,
//     required String categoryName,
//     required DateTime dueDate,
//     required bool reminderEnabled,
//     DateTime? reminderTime,
//     required bool status,
//   }) async {
//     try {
//       final updatedData = {
//         'taskTitle': taskTitle,
//         'categoryName': categoryName,
//         'dueDate': dueDate.toIso8601String(),
//         'reminderEnabled': reminderEnabled,
//         'reminderTime': reminderTime?.toIso8601String(),
//         'status': status,
//         'updatedAt': DateTime.now().toIso8601String(),
//       };
//
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('tasks')
//           .doc(taskId)
//           .update(updatedData);
//     } catch (e) {
//       print(' Failed to update task: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> deleteTask(String userId, String taskId) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('tasks')
//           .doc(taskId)
//           .delete();
//     } catch (e) {
//       print(' Failed to delete task: $e');
//       rethrow;
//     }
//   }
//
//   Stream<List<TaskModel>> getUserTasks(String userId) {
//     return _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('tasks')
//         .orderBy('dueDate')
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
//   }
// }
//
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TaskModel>> getUserTasks(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('taskTime')
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => TaskModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<void> addTask(String userId, TaskModel task) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toJson());
  }

  Future<void> updateTask(String userId, TaskModel task) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toJson());
  }

  Future<void> deleteTask(String userId, String taskId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}