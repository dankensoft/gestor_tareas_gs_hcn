import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_model.dart';
import '../repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repo);
});

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository repository;

  TaskNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await repository.getAll();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask(Task task) async {
    await repository.add(task);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await repository.update(task);
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await repository.delete(id);
    loadTasks();
  }
}
