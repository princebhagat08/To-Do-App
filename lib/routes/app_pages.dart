import 'package:get/get.dart';
import 'package:todo/screens/edit_task_screen/edit_task_screen.dart';
import '../controllers/task_controller.dart';
import '../screens/add_task_screen/add_task_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/todo_screen/todo_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [

    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),

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

    GetPage(
      name: AppRoutes.editTask,
      page: () => EditTaskScreen(task: Get.arguments),
    ),


  ];
}
