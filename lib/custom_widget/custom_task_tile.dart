import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String taskName;
  final String taskDescription;
  final String taskPriority;
  final String taskDueDate;
  final VoidCallback onViewTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const TaskTile({
    super.key,
    required this.taskName,
    required this.taskDescription,
    required this.taskPriority,
    required this.taskDueDate,
    required this.onViewTap,
    required this.onEditTap,
    required this.onDeleteTap,
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
              Text(taskDescription.length <= 15
                  ? taskDescription
                  : '${taskDescription.substring(0, 15)}...'),
              Text(taskDueDate),
            ],
          ),
          onTap: onViewTap,
          title: Text(taskName),
          trailing: Wrap(
            children: [
              IconButton(
                  onPressed: onEditTap,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: onDeleteTap,
                  icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
