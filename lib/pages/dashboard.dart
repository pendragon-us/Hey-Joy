import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/user_pref.dart';
import '../notification/notification.dart';
import '../utils/dashboard_container.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser;
  String selectedImage = '';

  @override
  void initState() {
    super.initState();
    DateTime scheduleTime = DateTime.now().add(Duration(seconds: 10));
    NotificationService.showScheduleNotification("Hey Cheif 😎", 'Its time to check your mood...', scheduleTime);
    listenToNotification();
    setState(() {
      selectedImage = UserPref.getImage();
    });
  }

  listenToNotification() {
    NotificationService.onClickNotification.stream.listen((event) {
      Navigator.pushNamed(context, '/emojiTracker');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //logo and user
            Container(
              color: Color(0xffD9D9D9),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('images/HeyJoylogo.png', width: 95, height: 95,),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, '/userProfile');
                          },
                          child: Image.asset(selectedImage, width: 65, height: 65,)
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/emojiTracker');
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Dashboard
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                          fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
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
              child: Center(
                child: SingleChildScrollView(
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
