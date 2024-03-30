import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/custom_widget/custom_dropdown.dart';
import 'package:todo/custom_widget/custom_task_tile.dart';
import 'package:todo/custom_widget/custom_textfield.dart';

class ToDoView extends StatefulWidget {
  const ToDoView({super.key});

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  List<Map> taskList = [];

  final TextEditingController TaskNameController = TextEditingController();
  final TextEditingController TaskDescriptionController =
      TextEditingController();
  final TextEditingController TaskDueDateController = TextEditingController();
  final TextEditingController TaskPriorityController = TextEditingController();

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
              DateFormat('dd-MMM - h:mm a').format(selectedDateTime!);
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
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    prefixIcon: const Icon(Icons.list_alt),
                    controller: TaskNameController,
                    label: 'Task Name',
                    autofocus: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    prefixIcon: const Icon(Icons.notes),
                    controller: TaskDescriptionController,
                    label: 'Task Description',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDropdown(
                    prefixIcon: const Icon(Icons.flag),
                    initialValue: TaskPriorityController.text,
                    label: 'Select Priority',
                    options: const ['Urgent', 'High', 'Normal', 'Low'],
                    onChanged: (value) {
                      setState(() {
                        TaskPriorityController.text = value.toString();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    prefixIcon: const Icon(Icons.calendar_today),
                    controller: TaskDueDateController,
                    label: 'Task Due Date',
                    readOnly: true,
                    onTap: () {
                      _selectDateTime(context);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close')),
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
    TaskPriorityController.text = 'Normal';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      prefixIcon: const Icon(Icons.list_alt),
                      controller: TaskNameController,
                      label: 'Task Name',
                      autofocus: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      prefixIcon: const Icon(Icons.notes),
                      controller: TaskDescriptionController,
                      label: 'Task Description',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropdown(
                      prefixIcon: const Icon(Icons.flag),
                      initialValue: 'Normal',
                      label: 'Select Priority',
                      options: const ['Urgent', 'High', 'Normal', 'Low'],
                      onChanged: (value) {
                        setState(() {
                          TaskPriorityController.text = value.toString();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      prefixIcon: const Icon(Icons.calendar_today),
                      controller: TaskDueDateController,
                      label: 'Task Due Date',
                      readOnly: true,
                      onTap: () {
                        _selectDateTime(context);
                      },
                    ),
                  ]),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close')),
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
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () {
                    taskList.removeAt(index);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Yes')),
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
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: ListView.builder(
              itemBuilder: (context, index) {
                return TaskTile(
                    taskName: taskList[index]['taskName'],
                    taskDescription: taskList[index]['taskDescription']
                                .length <=
                            15
                        ? taskList[index]['taskDescription']
                        : '${taskList[index]['taskDescription'].toString().substring(0, 15)}...',
                    taskPriority: taskList[index]['taskPriority'],
                    taskDueDate: taskList[index]['taskDueDate'],
                    onViewTap: () {
                      viewTask(index);
                    },
                    onEditTap: () {
                      updateTask(index);
                    },
                    onDeleteTap: () {
                      deleteTask(index);
                    });
              },
              itemCount: taskList.length),
        ),
        floatingActionButton: ElevatedButton.icon(
            onPressed: () {
              clearField();
              addTask();
            },
            icon: const Icon(Icons.add_task),
            label: const Text('Add')));
  }
}
