enum TaskPriority { low, medium, high }

class Task {
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });

  final int id;
  final String title;
  final String description;
  final TaskPriority priority;
  final DateTime dueDate;

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

