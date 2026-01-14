import 'package:flutter/material.dart';
import 'package:todo/constants/txt_style.dart';

import '../../../services/notification_service.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Your Task",
          style: xLargeBoldText,
        ),
        IconButton(onPressed: ()=>NotificationService.testScheduledNotification(), 
            icon: Icon(Icons.notifications))
      ],
    );
  }
}
