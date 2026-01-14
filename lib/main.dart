import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/app_theme.dart';
import 'package:todo/routes/app_pages.dart';
import 'package:todo/routes/app_routes.dart';


void main() {
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
      initialRoute: AppRoutes.todo,
      getPages: AppPages.pages,
    );
  }
}
