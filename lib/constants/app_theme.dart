
import 'package:flutter/material.dart';
import 'app_color.dart';

abstract class MyTheme {
  static final theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.backgroundColo,
  );
}