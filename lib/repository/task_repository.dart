import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskRepository {
  final String apiToken = "41a024e5980f8cebff0a8bf5e8dc866ed10b3749";
  final String FetchAction = 'tasks';
  final String isCompletedAction = '/close';
  final String BASE_URL = 'https://api.todoist.com/rest/v2/';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse(BASE_URL + FetchAction),
      headers: {
        'Authorization': 'Bearer $apiToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      print(data);
      return data.map((taskData) => Task.fromTodoistJson(taskData)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    final url = '$BASE_URL$FetchAction/$taskId$isCompletedAction';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update task status');
    }
  }

  Future<Task> createTask(String content) async {
    final url = Uri.parse(BASE_URL + FetchAction);
    String dueString = "tomorrow at 12:00";
    String dueLang = "en";
    int priority = 2;
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Request-Id': DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        'Authorization': 'Bearer $apiToken',
      },
      body: jsonEncode({
        'content': content,
        'due_string': dueString,
        'due_lang': dueLang,
        'priority': priority,
      }),
    );
    if (response.statusCode == 200 ) {
      final taskData = json.decode(response.body);
      return Task.fromTodoistJson(taskData);
    } else {
      throw Exception('Failed to create task');
    }
  }
  Future<Task> updateTask(String content,String taskId) async {
    final url = Uri.parse("$BASE_URL$FetchAction/$taskId");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Request-Id': DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        'Authorization': 'Bearer $apiToken',
      },
      body: jsonEncode({
        'content': content,
      }),
    );
    if (response.statusCode == 200 ) {
      final taskData = json.decode(response.body);
      return Task.fromTodoistJson(taskData);
    } else {
      throw Exception('Failed to create task');
    }
  }
}
