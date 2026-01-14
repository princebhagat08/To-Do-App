import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/routes/app_routes.dart';

import '../../../constants/txt_style.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/task.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Get.toNamed(AppRoutes.addTask);
          },
          child:  Text(
              "+ Add Task",
              style: mediumBoldWhiteText
          ),
        ),
      ),
    );
  }
}
