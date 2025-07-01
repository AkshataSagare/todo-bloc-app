import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TodoRepo {

  static void saveTask(TaskModel task) async {
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
}
