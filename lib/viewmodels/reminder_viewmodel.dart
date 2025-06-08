/* import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meal_app/models/task_model.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderViewModel extends ChangeNotifier {
  static final reminderCount = ValueNotifier<int>(0);
  final _notifications = FlutterLocalNotificationsPlugin();
  final Map<String, DateTime> notificationTimes = {};

  ReminderViewModel() {
    _initNotifications();
  }

  void _initNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
    tz.initializeTimeZones();
  }

  Future<void> fetchAndScheduleTodayReminders() async {
    final userId = UserSession.uid;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    final todayTasks = snapshot.docs.map((doc) =>
      TaskModel.fromFirestore(doc.data(), doc.id)
    ).where((task) =>
      task.enableReminder &&
      task.taskTime.year == today.year &&
      task.taskTime.month == today.month &&
      task.taskTime.day == today.day
    ).toList();

    for (var task in todayTasks) {
      await _scheduleNotification(task);
    }

    reminderCount.value = todayTasks.length;
  }

  Future<void> _scheduleNotification(TaskModel task) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Task Reminders',
      channelDescription: 'Reminders for scheduled tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.from(task.taskTime.subtract(const Duration(minutes: 10)), tz.local);
    notificationTimes[task.id] = scheduledTime;

    /* await _notifications.zonedSchedule(
      task.id.hashCode,
      'Reminder: ${task.title}',
      'Category: ${task.taskCategory}',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,      
      matchDateTimeComponents: DateTimeComponents.time,
    ); */
    try {
      await _notifications.zonedSchedule(
        task.id.hashCode,
        'Reminder: ${task.title}',
        'Category: ${task.taskCategory}',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Reminder scheduled for task: ${task.title} at $scheduledTime');
    } catch (e) {
      debugPrint('Failed to schedule reminder: $e');
    }

  }
}
 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meal_app/models/task_model.dart';
import 'package:meal_app/models/user_session.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderViewModel extends ChangeNotifier {
  static final reminderCount = ValueNotifier<int>(0);
  final ValueNotifier<List<TaskModel>> todayReminders = ValueNotifier([]);
  final _notifications = FlutterLocalNotificationsPlugin();
  final Map<String, DateTime> notificationTimes = {};

  ReminderViewModel() {
    _initNotifications();
  }

  void _initNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
    tz.initializeTimeZones();
  }

  Future<void> fetchAndScheduleTodayReminders() async {
    final userId = UserSession.uid;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    final todayTasks = snapshot.docs.map((doc) =>
      TaskModel.fromFirestore(doc.data(), doc.id)
    ).where((task) =>
      task.enableReminder &&
      task.taskTime.year == today.year &&
      task.taskTime.month == today.month &&
      task.taskTime.day == today.day
    ).toList();

    todayReminders.value = todayTasks;
    reminderCount.value = todayTasks.length;

    for (var task in todayTasks) {
      await _scheduleNotification(task);
    }
  }

  Future<void> _scheduleNotification(TaskModel task) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Task Reminders',
      channelDescription: 'Reminders for scheduled tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.from(
      task.taskTime.subtract(const Duration(minutes: 10)), tz.local);

    notificationTimes[task.id] = scheduledTime;

    try {
      await _notifications.zonedSchedule(
        task.id.hashCode,
        'Reminder: ${task.title}',
        'Category: ${task.taskCategory}',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Reminder scheduled for task: ${task.title} at $scheduledTime');
    } catch (e) {
      debugPrint('Failed to schedule reminder: $e');
    }
  }
}
