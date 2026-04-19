import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          return Center(child: Text("No tasks for today", style: mediumText));
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

  Widget _taskCard(BuildContext context, TaskController controller, Task task) {
    final isReadOnly = controller.isDateReadOnly(task.date);
    final bool done = task.isCompleted;
    final Color accentColor = _priorityColor(task.priority);

    return Opacity(
      opacity: done ? 0.6 : 1.0,
      child: GestureDetector(
        onTap:
            isReadOnly
                ? null
                : () => _showTaskOptions(context, controller, task),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: accentColor, width: 3.w)),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(14.r),
              bottomRight: Radius.circular(14.r),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 12.w,
                top: 12.h,
                bottom: 12.h,
                right: 8.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom checkbox
                  GestureDetector(
                    onTap:
                        isReadOnly ? null : () => controller.toggleTask(task),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20.w,
                      height: 20.w,
                      margin: EdgeInsets.only(top: 2.h),
                      decoration: BoxDecoration(
                        color: done ? accentColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          color:
                              done
                                  ? accentColor
                                  : Colors.grey.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child:
                          done
                              ? Icon(
                                Icons.check,
                                size: 13.sp,
                                color: Colors.white,
                              )
                              : null,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Title, chips, description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + chips row
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6.w,
                          runSpacing: 4.h,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color:
                                    done
                                        ? Colors.grey
                                        : Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                decoration:
                                    done
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                              ),
                            ),

                            _priorityChip(task.priority),
                            if (task.recurrence != TaskRecurrence.none)
                              _recurrenceChip(task.recurrence),

                            if (task.reminderTime != null)
                              _alarmIcon(accentColor),  
                          ],
                        ),

                       if(task.description.isNotEmpty) SizedBox(height: 6.h),

                        // Description
                       if(task.description.isNotEmpty) Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.5,
                            color:
                                done
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                            decoration:
                                done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),

                       SizedBox(height: 6.h),

                        Text(
                          DateFormat("hh:mm a").format(task.date),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                          
                        ),

                      
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Clock icon tinted with the task's priority color
  Widget _alarmIcon(Color color) {
    return SizedBox(
      width: 20.w,
      height: 20.w,
      child: CustomPaint(painter: _AlarmIconPainter(color: color)),
    );
  }

  Widget _priorityChip(TaskPriority priority) {
    final Color bg;
    final Color text;
    final String label;

    switch (priority) {
      case TaskPriority.low:
        bg = const Color(0xFFEAF3DE);
        text = const Color(0xFF27500A);
        label = "Low";
        break;
      case TaskPriority.medium:
        bg = const Color(0xFFFAEEDA);
        text = const Color(0xFF633806);
        label = "Medium";
        break;
      case TaskPriority.high:
        bg = const Color(0xFFFCEBEB);
        text = const Color(0xFFA32D2D);
        label = "High";
        break;
    }

    return _chip(label: label, bg: bg, textColor: text);
  }

  Widget _recurrenceChip(TaskRecurrence recurrence) {
    return _chip(
      label: _recurrenceLabel(recurrence),
      bg: const Color(0xFFEEEDFE),
      textColor: const Color(0xFF3C3489),
    );
  }

  Widget _chip({
    required String label,
    required Color bg,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF97C459);
      case TaskPriority.medium:
        return const Color(0xFFEF9F27);
      case TaskPriority.high:
        return const Color(0xFFE24B4A);
    }
  }

  void _showTaskOptions(
    BuildContext context,
    TaskController controller,
    Task task,
  ) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit Task"),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.editTask, arguments: task);
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

  String _recurrenceLabel(TaskRecurrence recurrence) {
    switch (recurrence) {
      case TaskRecurrence.none:
        return "No Repeat";
      case TaskRecurrence.daily:
        return "Daily";
      case TaskRecurrence.weekly:
        return "Weekly";
      case TaskRecurrence.monthly:
        return "Monthly";
    }
  }
}

/// Custom painter for a small clock/alarm icon tinted to priority color
class _AlarmIconPainter extends CustomPainter {
  final Color color;
  const _AlarmIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    // Circle
    canvas.drawCircle(center, radius, paint);

    // Hour hand
    canvas.drawLine(center, center + Offset(0, -radius * 0.6), paint);

    // Minute hand
    canvas.drawLine(center, center + Offset(radius * 0.5, 0), paint);

    // Bell legs at bottom
    final bellPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round;

    final path =
        Path()
          ..moveTo(center.dx - radius * 0.35, size.height * 0.88)
          ..quadraticBezierTo(
            center.dx,
            size.height,
            center.dx + radius * 0.35,
            size.height * 0.88,
          );
    canvas.drawPath(path, bellPaint);
  }

  @override
  bool shouldRepaint(_AlarmIconPainter old) => old.color != color;
}
