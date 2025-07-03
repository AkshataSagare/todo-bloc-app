import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TodoRepo {
  static Future<void> saveTask(TaskModel task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> taskStrings = prefs.getStringList('tasks') ?? [];
    taskStrings.add(jsonEncode(task.toJson()));

    prefs.setStringList('tasks', taskStrings);
  }

  static Future<List<TaskModel>> getAllTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<TaskModel> tasks = (prefs.getStringList('tasks') ?? [])
        .map((taskString) => TaskModel.fromJson(jsonDecode(taskString)))
        .toList();

    return tasks;
  }

  static Future<List<TaskModel>> markAsComplete(TaskModel task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<TaskModel> tasks = (prefs.getStringList('tasks') ?? [])
        .map((taskString) => TaskModel.fromJson(jsonDecode(taskString)))
        .toList();

    tasks[tasks.indexWhere((t) => t.id == task.id)] = task.copyWith(
      isCompleted: true,
    );

     prefs.setStringList(
      'tasks',
      tasks.map((t) => jsonEncode(t.toJson())).toList(),
    );
    return tasks;
  }
}
