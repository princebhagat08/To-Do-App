import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo/constants/txt_style.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_service.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;

  EditTaskScreen({super.key, required this.task});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final TaskController controller = Get.find();

  final selectedPriority = TaskPriority.medium.obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;
  final selectedRecurrence = TaskRecurrence.none.obs;

  final reminderEnabled = false.obs;
  final reminderDateTime = Rxn<DateTime>();

  @override
  Widget build(BuildContext context) {
    final isReadOnly = controller.isDateReadOnly(task.date);
    titleController.text = task.title;
    descriptionController.text = task.description;
    selectedPriority.value = task.priority;
    selectedDate.value = task.date;
    selectedTime.value = TimeOfDay.fromDateTime(task.date);
    selectedRecurrence.value = task.recurrence;

    if (task.reminderTime != null) {
      reminderEnabled.value = true;
      reminderDateTime.value = task.reminderTime;
    }

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
                _titleField(isReadOnly),
                SizedBox(height: 16.h),
                _descriptionField(isReadOnly),
                SizedBox(height: 20.h),
                _prioritySelector(isReadOnly),
                SizedBox(height: 20.h),
                _recurrenceSelector(isReadOnly),
                SizedBox(height: 20.h),
                _dateTimeCard(context, isReadOnly),
                SizedBox(height: 12.h),
                _reminderTile(context, isReadOnly),
                if (!isReadOnly) SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isReadOnly ? null : _saveButton(),
      floatingActionButtonLocation: isReadOnly ? null : FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Edit Task", style: xLargeBoldText),
        IconButton(
          icon: Icon(Icons.close, size: 22.sp),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Widget _titleField(bool isReadOnly) {
    return _inputContainer(
      TextField(
        controller: titleController,
        readOnly: isReadOnly,
        decoration: const InputDecoration(
          hintText: "Task title",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _descriptionField(bool isReadOnly) {
    return _inputContainer(
      TextField(
        controller: descriptionController,
        maxLines: 3,
        readOnly: isReadOnly,
        decoration: const InputDecoration(
          hintText: "Task description",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _prioritySelector(bool isReadOnly) {
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

                  Color color = switch (priority) {
                    TaskPriority.low => Colors.green,
                    TaskPriority.medium => Colors.orange,
                    TaskPriority.high => Colors.red,
                  };

                  return GestureDetector(
                    onTap: isReadOnly ? null : () => selectedPriority.value = priority,
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

  Widget _recurrenceSelector(bool isReadOnly) {
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
                onTap: isReadOnly ? null : () => selectedRecurrence.value = recurrence,
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

  Widget _dateTimeCard(BuildContext context, bool isReadOnly) {
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
              onTap: isReadOnly ? null : () async {
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
          Divider(height: 1.h),
          Obx(() {
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Due Time"),
              subtitle: Text(selectedTime.value.format(context)),
              onTap: isReadOnly ? null : () async {
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

  Widget _reminderTile(BuildContext context, bool isReadOnly) {
    return Obx(() {
      return _inputContainer(
        ListTile(
          leading: const Icon(Icons.alarm),
          title: const Text("Reminder"),
          subtitle: Text(
            reminderEnabled.value && reminderDateTime.value != null
                ? reminderDateTime.value.toString()
                : "No reminder set",
          ),
          trailing: Switch(
            value: reminderEnabled.value,
            onChanged: isReadOnly ? null : (value) async {
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

              reminderDateTime.value = DateTime(
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          onPressed: _updateTask,
          child: Text("Update Task", style: mediumBoldWhiteText),
        ),
      ),
    );
  }

  void _updateTask() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Task title is required");
      return;
    }

    final updatedDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    task.title = titleController.text.trim();
    task.description = descriptionController.text.trim();
    task.priority = selectedPriority.value;
    task.date = updatedDateTime;
    task.reminderTime = reminderEnabled.value ? reminderDateTime.value : null;
    task.recurrence = selectedRecurrence.value;

    task.save();
    controller.refreshTasks();

    if (task.reminderTime != null) {
      NotificationService.scheduleNotification(
        id: task.key,
        title: "Task Reminder",
        body: task.title,
        scheduledTime: task.reminderTime!,
      );
    }

    Get.back();
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
