import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo/constants/app_color.dart';
import 'package:todo/screens/todo_screen/widgets/add_task_button.dart';
import 'package:todo/screens/todo_screen/widgets/date_selector.dart';
import 'package:todo/screens/todo_screen/widgets/header.dart';
import 'package:todo/screens/todo_screen/widgets/search_bar.dart';
import 'package:todo/screens/todo_screen/widgets/task_list.dart';
import '../../controllers/task_controller.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});

  final TaskController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearSearch();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                SizedBox(height: 16.h),
                const DateSelector(),
                SizedBox(height: 16.h),
                SearchBarWidget(),
                SizedBox(height: 16.h),
                Divider(color: AppColor.grey),
                SizedBox(height: 16.h),
                const TaskList(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
        floatingActionButton: AddTaskButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
