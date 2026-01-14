import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Header(),
                DateSelector(),
                SearchBarWidget(),
                Divider(color: AppColor.grey,),
                TaskList(),
                SizedBox(height: 40)
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
