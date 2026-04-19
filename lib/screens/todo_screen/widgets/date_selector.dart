import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/task_controller.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();
    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 2));

          return Obx(() {
            final selected = controller.selectedDate.value;

            final isSelected =
                date.year == selected.year &&
                date.month == selected.month &&
                date.day == selected.day;

            return GestureDetector(
              onTap: () => controller.changeDate(date),
              child: Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${date.day}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _month(date),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isSelected ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  String _month(DateTime date) {
    const months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    return months[date.month - 1];
  }
}
