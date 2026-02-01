import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import '../models/task.dart';

class HomeWidgetService {
  static const String _widgetName = 'TodoWidgetProvider';
  static const String _tasksKey = 'widget_tasks';

  /// Initialize the home widget
  static Future<void> init() async {
    await HomeWidget.setAppGroupId('com.example.todo');
  }

  /// Update widget with today's tasks
  static Future<void> updateWidget(List<Task> allTasks) async {
    try {
      print(
        '[HomeWidget] Starting widget update with ${allTasks.length} total tasks',
      );

      // Filter today's tasks
      final now = DateTime.now();
      final todayTasks =
          allTasks.where((task) {
            return task.date.year == now.year &&
                task.date.month == now.month &&
                task.date.day == now.day;
          }).toList();

      print('[HomeWidget] Found ${todayTasks.length} tasks for today');

      // Sort by priority (high to low) and completion status
      todayTasks.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return b.priority.index.compareTo(a.priority.index);
      });

      // Take only first 10 tasks to avoid widget overflow
      final limitedTasks = todayTasks.take(10).toList();

      // Serialize tasks to JSON
      final tasksJson =
          limitedTasks.map((task) {
            return {
              'title': task.title,
              'description': task.description,
              'isCompleted': task.isCompleted,
              'priority': task.priority.index,
            };
          }).toList();

      final jsonString = jsonEncode(tasksJson);
      print('[HomeWidget] Saving JSON: $jsonString');

      // Save to widget
      await HomeWidget.saveWidgetData<String>(_tasksKey, jsonString);

      // Update widget
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
      );

      print('[HomeWidget] Widget update completed');
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  /// Clear widget data
  static Future<void> clearWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(_tasksKey, '[]');
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
      );
    } catch (e) {
      print('Error clearing widget: $e');
    }
  }
}
