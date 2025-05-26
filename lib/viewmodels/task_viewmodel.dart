
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