
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
  TaskModel copyWith({
    String? id,
    String? title,
    String? taskCategory,
    DateTime? taskTime,
    bool? enableReminder,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      taskCategory: taskCategory ?? this.taskCategory,
      taskTime: taskTime ?? this.taskTime,
      enableReminder: enableReminder ?? this.enableReminder,
    );
  }
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

