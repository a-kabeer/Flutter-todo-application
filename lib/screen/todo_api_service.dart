import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo/screen/todo_api_model.dart';

class ApiService {
  final String baseUrl =
      'https://crudcrud.com/api/a1c5014e53294f12b926bbfddc21c83d';
  final String resource = 'unicorns';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/$resource'));
    if (response.statusCode == 200) {
      return parseTasks(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$resource'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: taskToJson(task),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(String id, Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$resource/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: taskToJson(task),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$resource/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
