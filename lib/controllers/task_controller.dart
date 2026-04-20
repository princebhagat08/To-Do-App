import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';
import '../services/notification_service.dart';

const _widgetPlatform = MethodChannel('com.example.todo/update_widget');
const _widgetTasksKey = 'widget_tasks';
const _widgetCompletedTaskIdsKey = 'widget_completed_task_ids';

class TaskController extends GetxController {
  final selectedDate = DateTime.now().obs;
  var tasks = <Task>[].obs;
  final searchQuery = ''.obs;
  final addTaskTitle = ''.obs;

  final Box<Task> taskBox = Hive.box<Task>('tasksBox');
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  RxList<Task> filteredTasks = <Task>[].obs;

  DateTime get _todayStart => _startOfDay(DateTime.now());
  bool get isSelectedDateInPast => isDateReadOnly(selectedDate.value);
  bool get isAddTaskTitleValid => addTaskTitle.value.trim().isNotEmpty;

  @override
  void onInit() {
    everAll([selectedDate, tasks, searchQuery], (_) => _filterTasks());
    _filterTasks();
    loadTasks();
    super.onInit();
  }

  Future<void> loadTasks() async {
    await _pruneOldTasks();
    await _applyPendingWidgetCompletions();
    tasks.value = taskBox.values.toList();
    _filterTasks();
    sortByPriority();
    await syncWidgetTasks();
  }

  void addTask(Task task) {
    if (isDateReadOnly(task.date)) {
      Get.snackbar("Read only", "Past days are read only");
      return;
    }
    taskBox.add(task);
    loadTasks();
    clearAddTaskDraft();
  }

  void _filterTasks() {
    final query = searchQuery.value.toLowerCase();

    filteredTasks.value =
        tasks.where((t) {
          final sameDate =
              t.date.year == selectedDate.value.year &&
              t.date.month == selectedDate.value.month &&
              t.date.day == selectedDate.value.day;

          final matchesSearch =
              t.title.toLowerCase().contains(query) ||
              t.description.toLowerCase().contains(query);

          return sameDate && matchesSearch;
        }).toList();

    sortByPriority();
  }

  void sortByPriority() {
    filteredTasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      return b.priority.index.compareTo(a.priority.index);
    });

    filteredTasks.refresh();
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchFocusNode.unfocus();
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
  }

  void updateAddTaskTitle(String value) {
    addTaskTitle.value = value;
  }

  void clearAddTaskDraft() {
    addTaskTitle.value = '';
  }

  void toggleTask(Task task) {
    if (isDateReadOnly(task.date)) {
      return;
    }

    final wasIncomplete = !task.isCompleted;
    task.isCompleted = !task.isCompleted;
    task.save();
    if (wasIncomplete && task.recurrence != TaskRecurrence.none) {
      _createNextRecurringTask(task);
    }
    loadTasks();
  }

  void deleteTask(Task task) {
    if (isDateReadOnly(task.date)) {
      return;
    }
    NotificationService.cancelNotification(task.key);
    task.delete();
    loadTasks();
  }

  Future<void> deleteAllTasks() async {
    for (final task in taskBox.values) {
      if (task.key is int) {
        await NotificationService.cancelNotification(task.key as int);
      }
    }
    await taskBox.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_widgetCompletedTaskIdsKey);
    await loadTasks();
  }

  void refreshTasks() {
    tasks.value = taskBox.values.toList();
    _filterTasks();
    sortByPriority();
    syncWidgetTasks();
  }

  bool isDateReadOnly(DateTime date) {
    return _startOfDay(date).isBefore(_todayStart);
  }

  Future<void> syncWidgetTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final widgetTasks =
          tasks.where((task) => !task.isCompleted).toList()
            ..sort(_compareTasks);
      final payload =
          widgetTasks
              .map(
                (task) => {
                  'id': task.key,
                  'title': task.title.trim(),
                  'time': DateFormat('hh:mm a').format(task.date),
                  'dueAtMillis': task.date.millisecondsSinceEpoch,
                  'priority': _priorityLabel(task.priority),
                  'priorityIndex': task.priority.index,
                  'isCompleted': task.isCompleted,
                },
              )
              .toList();
      await prefs.setString(_widgetTasksKey, jsonEncode(payload));
      await _widgetPlatform.invokeMethod('updateWidget');
    } catch (_) {
      // Widget sync should not block task operations.
    }
  }

  Future<void> _applyPendingWidgetCompletions() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingIdsRaw = prefs.getString(_widgetCompletedTaskIdsKey);
    if (pendingIdsRaw == null || pendingIdsRaw.isEmpty) {
      return;
    }

    final decoded = jsonDecode(pendingIdsRaw);
    if (decoded is! List) {
      await prefs.remove(_widgetCompletedTaskIdsKey);
      return;
    }

    final pendingIds =
        decoded
            .whereType<num>()
            .map((id) => id.toInt())
            .toSet();

    if (pendingIds.isEmpty) {
      await prefs.remove(_widgetCompletedTaskIdsKey);
      return;
    }

    for (final task in taskBox.values) {
      final key = task.key;
      if (key is int && pendingIds.contains(key) && !task.isCompleted) {
        task.isCompleted = true;
        if (task.recurrence != TaskRecurrence.none) {
          _createNextRecurringTask(task);
        }
        await task.save();
        NotificationService.cancelNotification(key);
      }
    }

    await prefs.remove(_widgetCompletedTaskIdsKey);
  }

  Future<void> _pruneOldTasks() async {
    final cutoff = _todayStart.subtract(const Duration(days: 2));
    final staleTasks = taskBox.values.where((task) => _startOfDay(task.date).isBefore(cutoff)).toList();
    for (final task in staleTasks) {
      if (task.key is int) {
        await NotificationService.cancelNotification(task.key as int);
      }
      await task.delete();
    }
  }

  int _compareTasks(Task a, Task b) {
    if (a.isCompleted != b.isCompleted) {
      return a.isCompleted ? 1 : -1;
    }

    final priorityCompare = b.priority.index.compareTo(a.priority.index);
    if (priorityCompare != 0) {
      return priorityCompare;
    }

    return a.date.compareTo(b.date);
  }

  void _createNextRecurringTask(Task task) {
    final nextDate = _nextRecurringDate(task.date, task.recurrence);
    final nextReminder = _nextReminderTime(task.date, nextDate, task.reminderTime);

    taskBox.add(
      Task(
        title: task.title,
        description: task.description,
        date: nextDate,
        reminderTime: nextReminder,
        priority: task.priority,
        recurrence: task.recurrence,
      ),
    );
  }

  DateTime _nextRecurringDate(DateTime date, TaskRecurrence recurrence) {
    switch (recurrence) {
      case TaskRecurrence.none:
        return date;
      case TaskRecurrence.daily:
        return date.add(const Duration(days: 1));
      case TaskRecurrence.weekly:
        return date.add(const Duration(days: 7));
      case TaskRecurrence.monthly:
        return DateTime(date.year, date.month + 1, date.day, date.hour, date.minute);
    }
  }

  DateTime? _nextReminderTime(DateTime currentDate, DateTime nextDate, DateTime? reminderTime) {
    if (reminderTime == null) {
      return null;
    }
    final difference = currentDate.difference(reminderTime);
    return nextDate.subtract(difference);
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
