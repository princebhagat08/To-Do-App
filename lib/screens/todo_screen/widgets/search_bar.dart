import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/task_controller.dart';


class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  final TaskController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.updateSearch,
      decoration: InputDecoration(
        hintText: "Search tasks...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
