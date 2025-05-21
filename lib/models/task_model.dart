class TaskModel {
  final String taskId;
  final String userId;
  final String categoryName;
  final String taskTitle;
  final DateTime dueDate;
  final bool status;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final DateTime createdAt;

  TaskModel({
    required this.taskId,
    required this.userId,
    required this.categoryName,
    required this.taskTitle,
    required this.dueDate,
    required this.status,
    required this.reminderEnabled,
    required this.reminderTime,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json, String id) {
    return TaskModel(
      taskId: id,
      userId: json['userId'],
      categoryName: json['categoryName'],
      taskTitle: json['taskTitle'],
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      reminderEnabled: json['reminderEnabled'],
      reminderTime: json['reminderTime'] != null
          ? DateTime.tryParse(json['reminderTime'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'categoryName': categoryName,
      'taskTitle': taskTitle,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'reminderEnabled': reminderEnabled,
      'reminderTime': reminderTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
