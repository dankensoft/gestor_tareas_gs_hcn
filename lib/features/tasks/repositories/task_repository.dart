import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task_model.dart';

class TaskRepository {
  static const String keyTasks = 'tasks';

  Future<List<Task>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(keyTasks) ?? [];
    return data.map((e) => Task.fromJson(jsonDecode(e))).toList();
  }

  Future<void> add(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAll();
    tasks.add(task);
    final data = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(keyTasks, data);
  }

  Future<void> update(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAll();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
    }
    final data = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(keyTasks, data);
  }

  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAll();
    tasks.removeWhere((t) => t.id == id);
    final data = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(keyTasks, data);
  }
}
