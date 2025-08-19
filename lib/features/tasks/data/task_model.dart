import 'package:uuid/uuid.dart';

const _uuid = Uuid();

enum TaskStatus { pending, completed, failed }

enum FailReason { timeout, error, canceled }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final FailReason? failReason;

  Task({
    String? id,
    required this.title,
    required this.description,
    this.status = TaskStatus.pending,
    this.failReason,
  }) : id = id ?? _uuid.v4();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    FailReason? failReason,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      failReason: failReason,
    );
  }
}
