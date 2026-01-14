import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/txt_style.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';


class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TaskController controller = Get.find();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedPriority = TaskPriority.medium.obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topRow(),
              const SizedBox(height: 24),
              _titleField(),
              const SizedBox(height: 16),
              _descriptionField(),
              const SizedBox(height: 20),
              _prioritySelector(),
              const SizedBox(height: 20),
              _dateTimeCard(context),
              const Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: _saveButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          "Add Task",
          style: xLargeBoldText,
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }


  Widget _titleField() {
    return _inputContainer(
      TextField(
        controller: titleController,
        decoration: const InputDecoration(
          hintText: "Task title",
          border: InputBorder.none,
        ),
      ),
    );
  }


  Widget _descriptionField() {
    return _inputContainer(
      TextField(
        controller: descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Task description",
          border: InputBorder.none,
        ),
      ),
    );
  }


  Widget _prioritySelector() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Priority",style: mediumBoldText,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: TaskPriority.values.map((priority) {
              final isSelected = selectedPriority.value == priority;

              Color color;
              switch (priority) {
                case TaskPriority.low:
                  color = Colors.green;
                  break;
                case TaskPriority.medium:
                  color = Colors.orange;
                  break;
                case TaskPriority.high:
                  color = Colors.red;
                  break;
              }

              return GestureDetector(
                onTap: () => selectedPriority.value = priority,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.15) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    priority.name.capitalizeFirst!,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      );
    });
  }


  Widget _dateTimeCard(BuildContext context) {
    return _inputContainer(
      Column(
        children: [
          Obx(() {
            return ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text("Date"),
              subtitle: Text(
                "${selectedDate.value.day}-${selectedDate.value.month}-${selectedDate.value.year}",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  firstDate:
                  DateTime.now().subtract(const Duration(days: 2)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) selectedDate.value = picked;
              },
            );
          }),
          const Divider(height: 1),
          Obx(() {
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Time"),
              subtitle: Text(selectedTime.value.format(context)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime.value,
                );
                if (picked != null) selectedTime.value = picked;
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _saveButton() {
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
          onPressed: _saveTask,
          child: Text(
            "Add Task",
            style: mediumBoldWhiteText,
          ),
        ),
      ),
    );
  }


  void _saveTask() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Task title is required");
      return;
    }

    final date = selectedDate.value;
    final time = selectedTime.value;

    final dueDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    controller.addTask(
      Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: selectedPriority.value,
        dueDate: dueDateTime,
      ),
    );

    Get.back();
  }


  Widget _inputContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }



}
