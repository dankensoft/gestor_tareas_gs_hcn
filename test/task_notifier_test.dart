import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../lib/features/tasks/data/task_model.dart';
import '../lib/features/tasks/logic/task_provider.dart';
import '../lib/features/tasks/repositories/task_repository.dart';

void main() {
  group('TaskNotifier Tests', () {
    late TaskRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = TaskRepository();
      container = ProviderContainer(overrides: [
        taskRepositoryProvider.overrideWithValue(repository),
      ]);
    });

    test('Agregar tarea', () async {
      final notifier = container.read(taskNotifierProvider.notifier);
      final task = Task(title: "Test", description: "Test Desc");

      await notifier.addTask(task);
      final tasks = container.read(taskNotifierProvider).value!;

      expect(tasks.length, 1);
      expect(tasks.first.title, "Test");
    });

    test('Actualizar tarea', () async {
      final notifier = container.read(taskNotifierProvider.notifier);
      final task = Task(title: "Test", description: "Test Desc");
      await notifier.addTask(task);

      final updatedTask = task.copyWith(title: "Updated");
      await notifier.updateTask(updatedTask);

      final tasks = container.read(taskNotifierProvider).value!;
      expect(tasks.first.title, "Updated");
    });

    test('Eliminar tarea', () async {
      final notifier = container.read(taskNotifierProvider.notifier);
      final task = Task(title: "Test", description: "Test Desc");
      await notifier.addTask(task);

      await notifier.deleteTask(task.id);
      final tasks = container.read(taskNotifierProvider).value!;
      expect(tasks.isEmpty, true);
    });
  });
}
