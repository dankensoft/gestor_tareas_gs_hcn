import 'dart:async';
import '../data/task_model.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  Future<List<Task>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_tasks);
  }

  Future<void> add(Task task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.add(task);
  }

  Future<void> update(Task task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.removeWhere((t) => t.id == id);
  }
}
