import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String taskName;
  final String taskDescription;
  final String taskPriority;
  final String taskDueDate;
  final VoidCallback onViewTap;
  final VoidCallback onLongPress;

  const TaskTile({
    super.key,
    required this.taskName,
    required this.taskDescription,
    required this.taskPriority,
    required this.taskDueDate,
    required this.onViewTap,
    required this.onLongPress,
  });
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.yellow;
      case 'normal':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors
            .grey; // Default color for unspecified or unknown priorities
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white12,
          leading: CircleAvatar(
            radius: 25,
            child: Icon(Icons.flag, color: _getPriorityColor(taskPriority)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskDescription,
                style: const TextStyle(fontSize: 11),
              ),
              Text(taskDueDate, style: const TextStyle(fontSize: 12)),
            ],
          ),
          onLongPress: onLongPress,
          onTap: onViewTap,
          title: Text(
            taskName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
