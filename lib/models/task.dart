import 'package:hive/hive.dart';

part 'task.g.dart';



@HiveType(typeId: 1)
enum TaskPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,
}

@HiveType(typeId: 2)
enum TaskRecurrence {
  @HiveField(0)
  none,

  @HiveField(1)
  daily,

  @HiveField(2)
  weekly,

  @HiveField(3)
  monthly,
}


@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime? reminderTime;

  @HiveField(5)
  TaskPriority priority;

  @HiveField(6)
  TaskRecurrence recurrence;

  Task({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
    this.reminderTime,
    this.priority = TaskPriority.medium,
    this.recurrence = TaskRecurrence.none,
  });
}

