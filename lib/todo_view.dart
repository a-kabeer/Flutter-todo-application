import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ToDoView extends StatefulWidget {
  const ToDoView({super.key});

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  List<Map> taskList = [];
  List<String> dropDownPriority = ['Urgent', 'High', 'Normal', 'Low'];

  final TextEditingController TaskNameController = TextEditingController();
  final TextEditingController TaskDescriptionController =
      TextEditingController();
  final TextEditingController TaskDueDateController = TextEditingController();
  final TextEditingController TaskPriorityController = TextEditingController();

  // final TextEditingController _updateTaskNameController =
  //     TextEditingController();
  // final TextEditingController _updateTaskDescriptionController =
  //     TextEditingController();
  // final TextEditingController _updateTaskDueDate = TextEditingController();
  // final TextEditingController _updateTaskPriority = TextEditingController();

  DateTime? selectedDateTime;
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          TaskDueDateController.text =
              DateFormat('yyyy-MM-dd - HH:mm').format(selectedDateTime!);
        });
      }
    }
  }

  updateTask(index) {
    TaskNameController.text = taskList[index]['taskName'];
    TaskDescriptionController.text = taskList[index]['taskDescription'];
    TaskDueDateController.text = taskList[index]['taskDueDate'];
    TaskPriorityController.text = taskList[index]['taskPriority'];
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Task'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  controller: TaskNameController,
                ),
                TextField(
                  controller: TaskDescriptionController,
                ),
                TextField(
                  controller: TaskPriorityController,
                ),
                TextField(
                  controller: TaskDueDateController,
                  readOnly: true,
                  onTap: () {
                    _selectDateTime(context);
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    taskList[index]['taskName'] = TaskNameController.text;
                    taskList[index]['taskDescription'] =
                        TaskDescriptionController.text;
                    taskList[index]['taskDueDate'] = TaskDueDateController.text;
                    taskList[index]['taskPriority'] =
                        TaskPriorityController.text;
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Update')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  clearField() {
    TaskNameController.clear();
    TaskDescriptionController.clear();
    TaskDueDateController.clear();
    TaskPriorityController.clear();
  }

  addTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    autofocus: true,
                    controller: TaskNameController,
                  ),
                  TextField(
                    controller: TaskDescriptionController,
                  ),
                  TextField(
                    controller: TaskPriorityController,
                  ),
                  TextField(
                    controller: TaskDueDateController,
                    readOnly: true,
                    onTap: () {
                      _selectDateTime(context);
                    },
                  ),
                ]),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    taskList.add(
                      {
                        'taskName': TaskNameController.text,
                        'taskDescription': TaskDescriptionController.text,
                        'taskDueDate': TaskDueDateController.text,
                        'taskPriority': TaskPriorityController.text
                      },
                    );
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Add')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  deleteTask(index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Task'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to delete?'),
                Text('${taskList[index]['taskName']}'),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    taskList.removeAt(index);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Yes')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  viewTask(index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("${taskList[index]['taskName']}"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Description: ${taskList[index]['taskDescription']}"),
                Text("Priority: ${taskList[index]['taskPriority']}"),
                Text("Due Date: ${taskList[index]['taskDueDate']}")
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do Application'),
          backgroundColor: Colors.blue,
          titleTextStyle: const TextStyle(color: Colors.white),
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.white38,
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: dropDownPriority[0] == 'red'
                        ? Colors.red
                        : Colors.green,
                    foregroundColor: Colors.amber,
                    child: const Icon(
                      Icons.flag,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(taskList[index]['taskDescription'].length <= 5
                          ? taskList[index]['taskDescription']
                          : '${taskList[index]['taskDescription'].toString().substring(0, 5)}...'),
                      const Text('-'),
                      Text(taskList[index]['taskPriority']),
                      const Text('-'),
                      Text(taskList[index]['taskDueDate']),
                    ],
                  ),
                  onTap: () {
                    viewTask(index);
                  },
                  title: Text(taskList[index]['taskName']),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () {
                          updateTask(index);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteTask(index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: taskList.length),
        ),
        floatingActionButton: ElevatedButton.icon(
            onPressed: () {
              clearField();
              addTask();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add')));
  }
}
