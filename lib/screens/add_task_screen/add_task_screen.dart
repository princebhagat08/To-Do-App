import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/txt_style.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_service.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key}) {
    controller.clearAddTaskDraft();
  }

  final TaskController controller = Get.find();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedPriority = TaskPriority.medium.obs;
  late final Rx<DateTime> selectedDate = controller.selectedDate.value.obs;
  final selectedTime = TimeOfDay.now().obs;
  final selectedRecurrence = TaskRecurrence.none.obs;

  final reminderEnabled = false.obs;
  final reminderDateTime = Rxn<DateTime>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topRow(),
                SizedBox(height: 24.h),
                _titleField(),
                SizedBox(height: 16.h),
                _descriptionField(),
                SizedBox(height: 20.h),
                _prioritySelector(),
                SizedBox(height: 20.h),
                _recurrenceSelector(),
                SizedBox(height: 20.h),
                _dateTimeCard(context),
                SizedBox(height: 12.h),
                _reminderTile(context),
                SizedBox(height: 80.h),
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
          icon: Icon(Icons.close, size: 22.sp),
          onPressed: () {
            controller.clearAddTaskDraft();
            Get.back();
          },
        ),
      ],
    );
  }

  Widget _titleField() {
    return _inputContainer(
      TextField(
        controller: titleController,
        onChanged: controller.updateAddTaskTitle,
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
            padding: EdgeInsets.only(left: 8.w),
            child: Text("Priority", style: mediumBoldText),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children:
                TaskPriority.values.map((priority) {
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? color.withValues(alpha: 0.15)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        priority.name.capitalizeFirst!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      );
    });
  }

  Widget _recurrenceSelector() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text("Repeat", style: mediumBoldText),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: TaskRecurrence.values.map((recurrence) {
              final isSelected = selectedRecurrence.value == recurrence;
              return GestureDetector(
                onTap: () => selectedRecurrence.value = recurrence,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purple.withValues(alpha: 0.12) : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _recurrenceLabel(recurrence),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
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
                if (picked != null) {
                  selectedDate.value = picked;
                  _clearReminderIfInvalid();
                }
              },
            );
          }),
          Divider(height: 1.h),
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
                if (picked != null) {
                  selectedTime.value = picked;
                  _clearReminderIfInvalid();
                }
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
            reminderEnabled.value && reminderDateTime.value != null
                ? DateFormat('dd-MM-yyyy hh:mm a').format(reminderDateTime.value!)
                : "No reminder set",
          ),
          trailing: Switch(
            value: reminderEnabled.value,
            onChanged: (value) async {
              reminderEnabled.value = value;

              if (!value) {
                reminderDateTime.value = null;
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

              if (!context.mounted) return;

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (time == null) {
                reminderEnabled.value = false;
                return;
              }

              final selectedReminder = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );

              if (_isReminderBeforeNow(selectedReminder)) {
                reminderEnabled.value = false;
                reminderDateTime.value = null;
                Get.snackbar(
                  "Invalid reminder",
                  "Reminder time cannot be before the current time",
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.black,
                  backgroundColor: Colors.white,
                );
                return;
              }

              if (_isReminderAfterDueDate(selectedReminder)) {
                reminderEnabled.value = false;
                reminderDateTime.value = null;
                Get.snackbar(
                  "Invalid reminder",
                  "Reminder must be on or before the due date and time",
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.black,
                  backgroundColor: Colors.white,
                );
                return;
              }

              reminderDateTime.value = selectedReminder;
            },
          ),
        ),
      );
    });
  }

  Widget _saveButton() {
    return Obx(() {
      final isEnabled = controller.isAddTaskTitleValid;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? Colors.purple : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: isEnabled ? _saveTask : null,
            child: Text("Add Task", style: mediumBoldWhiteText),
          ),
        ),
      );
    });
  }

  void _saveTask() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Task title is required");
      return;
    }

    if (controller.isDateReadOnly(selectedDate.value)) {
      Get.snackbar("Read only", "Past days are read only",snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final dueDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    if (reminderEnabled.value &&
        reminderDateTime.value != null &&
        _isReminderBeforeNow(reminderDateTime.value!)) {
      Get.snackbar(
        "Invalid reminder",
        "Reminder time cannot be before the current time",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.white,
      );
      return;
    }

    if (reminderEnabled.value &&
        reminderDateTime.value != null &&
        _isReminderAfterDueDate(reminderDateTime.value!)) {
      Get.snackbar(
        "Invalid reminder",
        "Reminder must be on or before the due date and time",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.white,
      );
      return;
    }

    final task = Task(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      date: dueDateTime,
      priority: selectedPriority.value,
      reminderTime: reminderEnabled.value ? reminderDateTime.value : null,
      recurrence: selectedRecurrence.value,
    );

    controller.addTask(task);

    final taskId = task.key;
    print("---> taskId $taskId");
    if (reminderEnabled.value &&
        reminderDateTime.value != null &&
        taskId is int) {
      NotificationService.scheduleNotification(
        id: taskId,
        title: "Task Reminder",
        body: task.title,
        scheduledTime: reminderDateTime.value!,
      );
      Get.back();
    }else{
      Get.back();
    }


  }

  Widget _inputContainer(Widget child) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  DateTime _dueDateTime() {
    return DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );
  }

  bool _isReminderAfterDueDate(DateTime reminder) {
    return reminder.isAfter(_dueDateTime());
  }

  bool _isReminderBeforeNow(DateTime reminder) {
    return reminder.isBefore(DateTime.now());
  }

  void _clearReminderIfInvalid() {
    final reminder = reminderDateTime.value;
    if (reminder == null) {
      return;
    }

    if (_isReminderBeforeNow(reminder)) {
      reminderEnabled.value = false;
      reminderDateTime.value = null;
      Get.snackbar(
        "Reminder cleared",
        "Reminder was removed because it was before the current time",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_isReminderAfterDueDate(reminder)) {
      return;
    }

    reminderEnabled.value = false;
    reminderDateTime.value = null;
    Get.snackbar(
      "Reminder cleared",
      "Reminder was removed because it was after the due date and time",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _recurrenceLabel(TaskRecurrence recurrence) {
    switch (recurrence) {
      case TaskRecurrence.none:
        return "Doesn't repeat";
      case TaskRecurrence.daily:
        return "Daily";
      case TaskRecurrence.weekly:
        return "Weekly";
      case TaskRecurrence.monthly:
        return "Monthly";
    }
  }
}
