import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/app_theme.dart';


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
      home: null
    );
  }
}
