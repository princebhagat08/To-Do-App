import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/txt_style.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_service.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TaskController controller = Get.find();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedPriority = TaskPriority.medium.obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;
  
  final reminderEnabled = false.obs;
  DateTime? reminderDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                const SizedBox(height: 12),
                _reminderTile(context),
                SizedBox(height: 80,)
              ],
            ),
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
        Text("Add Task", style: xLargeBoldText),
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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text("Priority", style: mediumBoldText),
          ),
          const SizedBox(height: 10),
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
              title: const Text("Due Date"),
              subtitle: Text(
                "${selectedDate.value.day}-${selectedDate.value.month}-${selectedDate.value.year}",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  firstDate: DateTime.now(),
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
              title: const Text("Due Time"),
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

  Widget _reminderTile(BuildContext context) {
    return Obx(() {
      return _inputContainer(
        ListTile(
          leading: const Icon(Icons.alarm),
          title: const Text("Reminder"),
          subtitle: Text(
            reminderEnabled.value && reminderDateTime != null
                ? reminderDateTime.toString()
                : "No reminder set",
          ),
          trailing: Switch(
            value: reminderEnabled.value,
            onChanged: (value) async {
              reminderEnabled.value = value;

              if (!value) {
                reminderDateTime = null;
                return;
              }

              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate.value,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );

              if (date == null) {
                reminderEnabled.value = false;
                return;
              }

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (time == null) {
                reminderEnabled.value = false;
                return;
              }

              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            },
          ),
        ),
      );
    });
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
          child: Text("Add Task", style: mediumBoldWhiteText),
        ),
      ),
    );
  }



  void _saveTask() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Task title is required");
      return;
    }

    final dueDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    final task = Task(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      date: dueDateTime,
      priority: selectedPriority.value,
      reminderTime: reminderEnabled.value ? reminderDateTime : null,
    );

    controller.addTask(task);


    if (reminderEnabled.value && reminderDateTime != null) {
      NotificationService.scheduleNotification(
        id:  task.key,
        title: "Task Reminder",
        body: task.title,
        scheduledTime: reminderDateTime!,
      );
    }

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
