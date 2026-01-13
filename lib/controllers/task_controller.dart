import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task.dart';


class TaskController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final tasks = <Task>[].obs;
  final searchQuery = ''.obs;

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  RxList<Task> filteredTasks = <Task>[].obs;

  @override
  void onInit() {
    everAll([selectedDate, tasks, searchQuery], (_) => _filterTasks());
    _filterTasks();
    super.onInit();
  }


  void _filterTasks() {
    final query = searchQuery.value.toLowerCase();

    filteredTasks.value = tasks.where((t) {
      final sameDate =
          t.dueDate.year == selectedDate.value.year &&
              t.dueDate.month == selectedDate.value.month &&
              t.dueDate.day == selectedDate.value.day;

      final matchesSearch =
          t.title.toLowerCase().contains(query) ||
              t.description.toLowerCase().contains(query);

      return sameDate && matchesSearch;
    }).toList();
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

  void addTask(Task task) {
    tasks.add(task);
  }


  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

}

