import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/task_controller.dart';

import '../../../models/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();
    return Expanded(
      child: Obx(() {
        if (controller.filteredTasks.isEmpty) {
          return const Center(
            child: Text("No tasks for today"),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = controller.filteredTasks[index];
            return _taskCard(task);
          },
        );
      }),
    );
  }


  Widget _taskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            task.description,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          _priorityChip(task.priority),
        ],
      ),
    );
  }


  Widget _priorityChip(TaskPriority priority) {
    Color color;
    String text;

    switch (priority) {
      case TaskPriority.low:
        color = Colors.green;
        text = "Low";
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        text = "Medium";
        break;
      case TaskPriority.high:
        color = Colors.red;
        text = "High";
        break;
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }


}
