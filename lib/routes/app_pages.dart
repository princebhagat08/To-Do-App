import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../screens/add_task_screen/add_task_screen.dart';
import '../screens/todo_screen/todo_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.todo,
      page: () => TodoScreen(),
      binding: BindingsBuilder(() {
        Get.put(TaskController());
      }),
    ),

    GetPage(
      name: AppRoutes.addTask,
      page: () => AddTaskScreen(),
    ),

  ];
}
