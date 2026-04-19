import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/task_controller.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  final TaskController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.updateSearch,
      decoration: InputDecoration(
        hintText: "Search tasks...",
        prefixIcon: Icon(Icons.search, size: 20.sp),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
