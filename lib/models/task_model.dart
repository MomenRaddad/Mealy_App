
class TaskModel {
  final String id;
  final String title;
  final String taskCategory;
  final DateTime taskTime;
  final bool enableReminder;

  TaskModel({
    required this.id,
    required this.title,
    required this.taskCategory,
    required this.taskTime,
    required this.enableReminder,
  });

  factory TaskModel.fromFirestore(Map<String, dynamic> json, String id) {
    return TaskModel(
      id: id,
      title: json['title'],
      taskCategory: json['taskCategory'],
      taskTime: DateTime.parse(json['taskTime']),
      enableReminder: json['enableReminder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'taskCategory': taskCategory,
      'taskTime': taskTime.toIso8601String(),
      'enableReminder': enableReminder,
    };
  }
}

