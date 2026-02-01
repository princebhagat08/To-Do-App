import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/constants/app_theme.dart';
import 'package:todo/routes/app_pages.dart';
import 'package:todo/routes/app_routes.dart';
import 'package:todo/services/notification_service.dart';

import 'models/task.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  await Hive.openBox<Task>('tasksBox');
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo',
      theme: MyTheme.theme,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}


//  import 'package:flutter/material.dart';
//       import 'package:shared_preferences/shared_preferences.dart';
//       import 'package:flutter/services.dart';

//       const platform = MethodChannel('com.example.todo/update_widget');

//       void main() {
//         runApp(MyApp());
//       }

//       class MyApp extends StatelessWidget {
//         @override
//         Widget build(BuildContext context) {
//           return MaterialApp(
//             title: 'To-Do Widget App',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//             ),
//             home: TaskInputScreen(),
//           );
//         }
//       }

//       class TaskInputScreen extends StatefulWidget {
//         @override
//         _TaskInputScreenState createState() => _TaskInputScreenState();
//       }

//       class _TaskInputScreenState extends State<TaskInputScreen> {
//         final TextEditingController _taskController = TextEditingController();
//         String _tasks = ''; // Use a single string to store tasks
//         //method to update the widget
//         Future<void> _updateAndroidWidget() async {
//           try {
//             // First save data using SharedPreferences
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.setString('tasks', _tasks);

//             // Then notify the platform to update the widget
//             await platform.invokeMethod('updateWidget');
//           } catch (e) {
//             print('Error updating widget: $e');
//           }
//         }

//         void _saveTask() async {
//           String taskTitle = _taskController.text;
//           if (taskTitle.isNotEmpty) {
//             // Append the new task to the existing tasks
//             setState(() {
//               _tasks = _tasks.isEmpty ? taskTitle : '$_tasks,$taskTitle';
//             });
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.setString('tasks', _tasks); // Make sure the key matches

//             // Update the widget
//             await _updateAndroidWidget();

//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Task added!')),
//             );

//             _taskController.clear();
//           }
//         }

//         void _loadSavedTasks() async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           String tasksString = prefs.getString('tasks') ?? '';
//           if (tasksString.isNotEmpty) {
//             setState(() {
//               _tasks = tasksString;
//             });
//             // Update widget when tasks are loaded
//             await _updateAndroidWidget();
//           }
//         }

//         void _removeTask(int index) async {
//           List<String> taskList = _tasks.split(',');
//           if (index < taskList.length) {
//             taskList.removeAt(index);
//             setState(() {
//               _tasks = taskList.join(',');
//             });

//             // Update the widget
//             await _updateAndroidWidget();
//           }
//         }

//         @override
//         void initState() {
//           super.initState();
//           _loadSavedTasks();
//         }

//         @override
//         Widget build(BuildContext context) {
//           List<String> displayedTasks = _tasks.isNotEmpty
//               ? _tasks.split(',')
//               : []; // Create a list from the tasks string

//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('To-Do List'),
//             ),
//             body: ListView.builder(
//               itemCount: displayedTasks.length,
//               itemBuilder: (context, index) {
//                 return Dismissible(
//                   key: Key(displayedTasks[index]),
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: const Icon(Icons.delete, color: Colors.white),
//                   ),
//                   onDismissed: (direction) {
//                     _removeTask(index);
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text('Task removed!'),
//                     ));
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.all(10),
//                     elevation: 5,
//                     child: ListTile(
//                       title: Text(
//                         displayedTasks[index],
//                         style: const TextStyle(fontSize: 18),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             floatingActionButton: FloatingActionButton(
//               child: const Icon(Icons.add),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: const Text('Add Task'),
//                       content: TextField(
//                         controller: _taskController,
//                         decoration: const InputDecoration(hintText: 'Enter task'),
//                       ),
//                       actions: <Widget>[
//                         TextButton(
//                           child: const Text('Add'),
//                           onPressed: () {
//                             _saveTask();
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           );
//         }
//       }