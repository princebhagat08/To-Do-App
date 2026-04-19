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

  final Box<Task> taskBox = Hive.box<Task>('tasksBox');
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  RxList<Task> filteredTasks = <Task>[].obs;

  @override
  void onInit() {
    everAll([selectedDate, tasks, searchQuery], (_) => _filterTasks());
    _filterTasks();
    loadTasks();
    super.onInit();
  }

  Future<void> loadTasks() async {
    await _applyPendingWidgetCompletions();
    tasks.value = taskBox.values.toList();
    _filterTasks();
    sortByPriority();
    await syncWidgetTasks();
  }

  void addTask(Task task) {
    taskBox.add(task);
    loadTasks();
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

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save();
    loadTasks();
  }

  void deleteTask(Task task) {
    NotificationService.cancelNotification(task.key);
    task.delete();
    loadTasks();
  }

  void refreshTasks() {
    tasks.value = taskBox.values.toList();
    _filterTasks();
    sortByPriority();
    syncWidgetTasks();
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
        await task.save();
        NotificationService.cancelNotification(key);
      }
    }

    await prefs.remove(_widgetCompletedTaskIdsKey);
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

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
