
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/constants/app_color.dart';
import 'package:todo/routes/app_routes.dart';

import '../../models/task.dart';
import '../../services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

@override
  void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 3),
  );
  _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  _controller.forward();
  Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(AppRoutes.todo);
      });
  }

  // Future<void> _intililizedApp()async{
  //   await Hive.initFlutter();
  //   Hive.registerAdapter(TaskAdapter());
  //   Hive.registerAdapter(TaskPriorityAdapter());
  //   await Hive.openBox<Task>('tasksBox');
  //   await NotificationService.init();
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Get.offAllNamed(AppRoutes.todo);
  //   });
  // }

  // Future<void> _intililizedApp() async {
  //   try {
  //     // ⏳ Total init must finish within 5 seconds
  //     await Future.wait([
  //       _initHive(),
  //       _initNotifications(),
  //     ]).timeout(
  //       const Duration(seconds: 5),
  //       onTimeout: () {
  //         throw Exception('Initialization timeout');
  //       },
  //     );
  //   } catch (e, stack) {
  //     // ❗ Release mode silent crash protection
  //     debugPrint('❌ App init failed: $e');
  //     debugPrintStack(stackTrace: stack);
  //   } finally {
  //     // ✅ ALWAYS navigate (even if init fails)
  //     Future.delayed(const Duration(seconds: 2), () {
  //       if (Get.currentRoute == AppRoutes.splash) {
  //         Get.offAllNamed(AppRoutes.todo);
  //       }
  //     });
  //   }
  // }


  // Future<void> _initHive() async {
  //   await Hive.initFlutter();
  //
  //   if (!Hive.isAdapterRegistered(0)) {
  //     Hive.registerAdapter(TaskAdapter());
  //   }
  //   if (!Hive.isAdapterRegistered(1)) {
  //     Hive.registerAdapter(TaskPriorityAdapter());
  //   }
  //
  //   if (!Hive.isBoxOpen('tasksBox')) {
  //     await Hive.openBox<Task>('tasksBox');
  //   }
  // }
  //
  // Future<void> _initNotifications() async {
  //   await NotificationService.init();
  // }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        color: AppColor.backgroundColo,
        child:  ScaleTransition(
          scale: _animation,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/icon.png',width: mq.width*0.5,)
            ],
          ),
        ),
      ),
    );
  }
}
