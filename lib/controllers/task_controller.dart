import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../services/notification_service.dart';


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

  void loadTasks() {
    tasks.value = taskBox.values.toList();
    _filterTasks();
    sortByPriority();
  }

  void addTask(Task task) {
    taskBox.add(task);
    loadTasks();
    refreshTasks();
  }

  void _filterTasks() {
    final query = searchQuery.value.toLowerCase();

    filteredTasks.value = tasks.where((t) {
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
    refreshTasks();
  }

  void refreshTasks() {
    tasks.refresh();
    filteredTasks.refresh();
    sortByPriority();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

}

