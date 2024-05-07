import 'dart:convert';

class Task {
  final String? taskId;
  String taskName;
  String taskDescription;
  String taskDueDate;
  String taskPriority;

  Task({
    this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskDueDate,
    required this.taskPriority,
  });

  Task.fromJson(Map<String, dynamic> json)
      : taskId = json['_id'],
        taskName = json['taskName'],
        taskDescription = json['taskDescription'],
        taskDueDate = json['taskDueDate'],
        taskPriority = json['taskPriority'];

  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'taskDescription': taskDescription,
        'taskDueDate': taskDueDate,
        'taskPriority': taskPriority,
      };
}

List<Task> parseTasks(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Task>((json) => Task.fromJson(json)).toList();
}

String taskToJson(Task task) {
  final Map<String, dynamic> data = task.toJson();
  return jsonEncode(data);
}
