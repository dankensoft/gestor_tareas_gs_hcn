import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_model.dart';
import '../logic/task_provider.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Tareas")),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text("No hay tareas registradas"));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    _getStatusIcon(task.status),
                    color: _getStatusColor(task.status),
                  ),
                  title: Text(task.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.description.isNotEmpty) Text(task.description),
                      if (task.status == TaskStatus.failed &&
                          task.failReason != null)
                        Text(
                          "Razón: ${task.failReason.toString().split('.').last}",
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "completar") {
                        ref
                            .read(taskNotifierProvider.notifier)
                            .updateTask(task.copyWith(status: TaskStatus.completed));
                      } else if (value == "fallida") {
                        _showFailReasonDialog(context, ref, task);
                      } else if (value == "eliminar") {
                        ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "completar", child: Text("Marcar como completada")),
                      const PopupMenuItem(
                          value: "fallida", child: Text("Marcar como fallida")),
                      const PopupMenuItem(value: "eliminar", child: Text("Eliminar")),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending_actions;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.failed:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.failed:
        return Colors.red;
    }
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nueva Tarea"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Título"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: "Descripción"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final newTask = Task(
                    title: titleController.text,
                    description: descController.text,
                  );
                  ref.read(taskNotifierProvider.notifier).addTask(newTask);
                  Navigator.pop(context);
                }
              },
              child: const Text("Guardar")),
        ],
      ),
    );
  }

  void _showFailReasonDialog(BuildContext context, WidgetRef ref, Task task) {
    FailReason? selectedReason;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Selecciona la razón de falla"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: FailReason.values.map((reason) {
                return RadioListTile<FailReason>(
                  title: Text(reason.toString().split('.').last),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    setState(() => selectedReason = value);
                  },
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () {
                if (selectedReason != null) {
                  ref.read(taskNotifierProvider.notifier).updateTask(
                        task.copyWith(
                          status: TaskStatus.failed,
                          failReason: selectedReason,
                        ),
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text("Guardar")),
        ],
      ),
    );
  }
}
