import 'package:flutter/material.dart';
import 'package:hey_joy_application/notification/notification.dart';

class Testpage extends StatelessWidget {
  const Testpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              ElevatedButton(
              onPressed: () async {
                NotificationService.showInstantNotification("instant notification", "waow instant");
              },
              child: const Text("Instant Notification"),
            ),
            ElevatedButton(
              onPressed: () async {
                DateTime scheduleTime = DateTime.now().add(Duration(seconds: 10));
                NotificationService.showScheduleNotification("schedule noti", 'this is amazing', scheduleTime);
              },
              child: const Text("Schedule Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
