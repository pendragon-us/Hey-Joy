import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService{

  static final FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();

  static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async {
    onClickNotification.add(notificationResponse.payload!);
  }


  static Future init() async{
    const AndroidInitializationSettings
      androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //show instant notification
  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails("channel_Id", "channel_name",
        importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.show(4, title, body, platformChannelSpecifics);
  }

  //show scheduled notification mood tracking with every 8 hours
  static Future<void> showScheduleNotification(String title, String body, DateTime scheduleTime) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails("channel_Id", "channel_name",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        title,
        body,
        RepeatInterval.daily,
        platformChannelSpecifics,
    );
  }

  //show scheduled notification for quotes every hour
  static Future<void> showScheduleNotificationForQuotes(String title, String body, DateTime scheduleTime) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails("channel_Id1", "channel_name1",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      title,
      body,
      RepeatInterval.hourly,
      platformChannelSpecifics,
    );
  }
}
