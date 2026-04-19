import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/txt_style.dart';

import '../../../controllers/task_controller.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Your Task", style: xLargeBoldText),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'delete_all') {
              Get.dialog(
                AlertDialog(
                  title: const Text("Delete all tasks?"),
                  content: const Text("This will remove all tasks and cancel their reminders."),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        await controller.deleteAllTasks();
                      },
                      child: const Text("Delete all"),
                    ),
                  ],
                ),
              );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(
              value: 'delete_all',
              child: Text("Delete all tasks"),
            ),
          ],
        ),
      ],
    );
  }
}
