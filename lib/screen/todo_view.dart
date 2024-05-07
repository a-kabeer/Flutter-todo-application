import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/custom_widget/custom_dropdown.dart';
import 'package:todo/custom_widget/custom_task_tile.dart';
import 'package:todo/custom_widget/custom_textfield.dart';
import 'package:todo/screen/todo_api_model.dart';
import 'package:todo/screen/todo_api_service.dart';

class ToDoView extends StatefulWidget {
  const ToDoView({super.key});

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  late ApiService api;

  @override
  void initState() {
    super.initState();
    api = ApiService();
    loadTasks();
  }

  int? selectedTaskIndex;

  bool showOptions = false;
  List taskList = [];
  void loadTasks() async {
    try {
      taskList = await api.fetchTasks();
      setState(() {});
    } catch (e) {
      print("Failed to load tasks: $e");
    }
  }

  Task task = Task(
      taskId: '_id',
      taskName: 'taskName',
      taskDescription: 'taskDescription',
      taskDueDate: 'taskDueDate',
      taskPriority: 'taskPriority');

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
                  onPressed: () async {
                    // taskList.add(
                    //   {
                    //     task.taskName: TaskNameController.text,
                    //     task.taskDescription: TaskDescriptionController.text,
                    //     task.taskDueDate: TaskDueDateController.text,
                    //     task.taskPriority: TaskPriorityController.text
                    //   },
                    // );
                    Task newTask = Task(
                        taskName: TaskNameController.text,
                        taskDescription: TaskDescriptionController.text,
                        taskDueDate: TaskDueDateController.text,
                        taskPriority: TaskPriorityController.text);
                    Navigator.pop(context);
                    await api.createTask(newTask);
                    loadTasks();
                    setState(() {});
                  },
                  child: const Text('Add')),
            ],
          );
        });
  }

  viewTask(index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("${taskList[index].taskName}"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Description: ${taskList[index].taskDescription}"),
                Text("Priority: ${taskList[index].taskPriority}"),
                Text("Due Date: ${taskList[index].taskDueDate}")
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

  updateTask(index) {
    TaskNameController.text = taskList[index].taskName;
    TaskDescriptionController.text = taskList[index].taskDescription;
    TaskDueDateController.text = taskList[index].taskDueDate;
    TaskPriorityController.text = taskList[index].taskPriority;
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
                  onPressed: () async {
                    Task updatedTask = taskList[index];
                    updatedTask.taskName = TaskNameController.text;
                    updatedTask.taskDescription =
                        TaskDescriptionController.text;
                    updatedTask.taskDueDate = TaskDueDateController.text;
                    updatedTask.taskPriority = TaskPriorityController.text;
                    Navigator.pop(context);

                    await api.updateTask(updatedTask.taskId ?? "", updatedTask);
                    setState(() {});
                  },
                  child: const Text('Update')),
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
                Text('${taskList[index].taskName}'),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () async {
                    Task deleteTask = taskList[index];
                    await api.deleteTask(deleteTask.taskId ?? "");
                    Navigator.pop(context);
                    loadTasks();
                    setState(() {});
                  },
                  child: const Text('Yes')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: showOptions && selectedTaskIndex != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text('To Do Application',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20)),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteTask(selectedTaskIndex);
                        setState(() {
                          showOptions = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        updateTask(selectedTaskIndex);
                        setState(() {
                          showOptions = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          showOptions = false;
                        });
                      },
                    )
                  ],
                )
              : const Text('To Do Application'),
          backgroundColor: Colors.blue,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              showOptions = false;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            child: GestureDetector(
              onHorizontalDragStart: (DragStartDetails details) {
                setState(() {
                  showOptions = false;
                });
              },
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return TaskTile(
                      taskName: taskList[index].taskName,
                      taskDescription: taskList[index].taskDescription.length <=
                              30
                          ? taskList[index].taskDescription
                          : '${taskList[index].taskDescription.toString().substring(0, 30)}...',
                      taskPriority: taskList[index].taskPriority,
                      taskDueDate: taskList[index].taskDueDate,
                      onViewTap: () {
                        viewTask(index);
                      },
                      onLongPress: () {
                        showOptions = true;
                        selectedTaskIndex = index;
                        setState(() {});
                      },
                    );
                  },
                  itemCount: taskList.length),
            ),
          ),
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
