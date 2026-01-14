import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();


  static Future<void> init() async {
    print("Notification init called");
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _notifications.initialize(settings);

    await _requestAndroidPermission();
  }


  static Future<void> _requestAndroidPermission() async {
    print("Calling permission");
    if (Platform.isAndroid) {
      final androidPlugin =
      _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final granted = await androidPlugin?.requestNotificationsPermission();
      print(" Notification permission granted: $granted");
    }
  }

  static Future<void> showInstantNotification() async {
    await _notifications.show(
      999,
      "Test Notification",
      "Notification is working",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> testScheduledNotification() async {
    final scheduledTime =
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    print("SCHEDULED TZ TIME: $scheduledTime");

    await _notifications.zonedSchedule(
      1111,
      "Scheduled Test",
      "If you see this, scheduling WORKS",
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_schedule_channel',
          'Scheduled Test',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("Scheduled test notification DONE");
  }





  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime scheduledTZ =
    tz.TZDateTime.from(scheduledTime, tz.local);


    if (scheduledTZ.isBefore(tz.TZDateTime.now(tz.local))) {
      Get.snackbar("Error", "Scheduled time cannot be in the past");
      return;
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTZ,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Task reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),


      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }



  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}
