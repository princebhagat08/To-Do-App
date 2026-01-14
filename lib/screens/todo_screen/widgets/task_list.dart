import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/txt_style.dart';
import 'package:todo/controllers/task_controller.dart';

import '../../../models/task.dart';
import '../../../routes/app_routes.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();

    return Expanded(
      child: Obx(() {
        if (controller.filteredTasks.isEmpty) {
          return Center(
            child: Text("No tasks for today", style: mediumText),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = controller.filteredTasks[index];
            return _taskCard(context, controller, task);
          },
        );
      }),
    );
  }



  Widget _taskCard(
      BuildContext context,
      TaskController controller,
      Task task,
      ) {
    return GestureDetector(
      onTap: () => _showTaskOptions(context, controller, task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => controller.toggleTask(task),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task.isCompleted
                                ? Colors.grey
                                : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _priorityChip(task.priority),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: task.isCompleted
                          ? Colors.grey
                          : Colors.grey.shade600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat("hh:mm a").format(task.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),


                if (task.reminderTime != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.alarm,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _priorityChip(TaskPriority priority) {
    late Color color;
    late String text;

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }



  void _showTaskOptions(
      BuildContext context,
      TaskController controller,
      Task task,
      ) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit Task"),
                onTap: () {
                  Get.back();
                  Get.toNamed(
                    AppRoutes.editTask,
                    arguments: task,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete Task"),
                onTap: () {
                  Get.back();
                  controller.deleteTask(task);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
