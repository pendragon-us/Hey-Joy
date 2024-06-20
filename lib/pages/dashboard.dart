import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../notification/notification.dart';
import '../utils/dashboard_container.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    DateTime scheduleTime = DateTime.now().add(Duration(seconds: 10));
    NotificationService.showScheduleNotification("Hey Cheif 😎", 'Its time to check your mood...', scheduleTime);
    listenToNotification();
  }

  listenToNotification() {
    NotificationService.onClickNotification.stream.listen((event) {
      Navigator.pushNamed(context, '/emojiTracker');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(
              image: AssetImage('images/appbarlogo.png'),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/userProfile');
                  },
                  child: Image(
                    image: AssetImage('images/avatar.png'),
                  ),
                ),
                IconButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/emojiTracker');
                    },
                    icon: Icon(
                      Icons.menu,
                      color: Color(0xffD9D9D9),
                    )
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard
          Container(
            margin: EdgeInsets.only(left: 30, top: 40),
            child: Column(
              children: [
                Text(
                  "Dashboard",
                  style: TextStyle(
                      fontSize: 24,

                  ),
                ),
                Container(
                  width: 130,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ),
          // Main buttons
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DashboardContainer(
                        containerColor: Color(0xffFF1212),
                        filePath: 'images/chatbot.png',
                        containerName: 'ChatBot',
                        onTap: () {
                          Navigator.pushNamed(context, '/chatbot');
                        },
                      ),
                    ),
                    Expanded(
                      child: DashboardContainer(
                        containerColor: Color(0xff00C2FF),
                        filePath: 'images/game.png',
                        containerName: 'Game',
                        onTap: () {
                          Navigator.pushNamed(context, '/game');
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DashboardContainer(
                        containerColor: Color(0xffFF7008),
                        filePath: 'images/journal.png',
                        containerName: 'Digital Journal',
                        onTap: () {
                          Navigator.pushNamed(context, '/journalOrCalender');
                        },
                      ),
                    ),
                    Expanded(
                      child: DashboardContainer(
                        containerColor: Color(0xff1E6BFF),
                        filePath: 'images/nortification.png',
                        containerName: 'Notification',
                        onTap: () {
                          Navigator.pushNamed(context, '/notification');
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
