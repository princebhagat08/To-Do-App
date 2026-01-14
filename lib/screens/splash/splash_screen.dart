
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/app_color.dart';
import 'package:todo/routes/app_routes.dart';



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
  _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 3),
  );
  _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  _controller.forward();
    _initializeApp();
    super.initState();
  }

  Future<void> _initializeApp()async{

    await Future.delayed(const Duration(seconds: 2));

    Get.offNamed(AppRoutes.todo);
  }

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
