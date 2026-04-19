// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      title: fields[0] as String,
      description: fields[1] as String,
      date: fields[2] as DateTime,
      isCompleted: fields[3] as bool,
      reminderTime: fields[4] as DateTime?,
      priority: fields[5] as TaskPriority,
      recurrence: fields[6] == null ? TaskRecurrence.none : fields[6] as TaskRecurrence,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.reminderTime)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.recurrence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 1;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.low;
      case 1:
        return TaskPriority.medium;
      case 2:
        return TaskPriority.high;
      default:
        return TaskPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.low:
        writer.writeByte(0);
        break;
      case TaskPriority.medium:
        writer.writeByte(1);
        break;
      case TaskPriority.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskRecurrenceAdapter extends TypeAdapter<TaskRecurrence> {
  @override
  final int typeId = 2;

  @override
  TaskRecurrence read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskRecurrence.none;
      case 1:
        return TaskRecurrence.daily;
      case 2:
        return TaskRecurrence.weekly;
      case 3:
        return TaskRecurrence.monthly;
      default:
        return TaskRecurrence.none;
    }
  }

  @override
  void write(BinaryWriter writer, TaskRecurrence obj) {
    switch (obj) {
      case TaskRecurrence.none:
        writer.writeByte(0);
        break;
      case TaskRecurrence.daily:
        writer.writeByte(1);
        break;
      case TaskRecurrence.weekly:
        writer.writeByte(2);
        break;
      case TaskRecurrence.monthly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskRecurrenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
