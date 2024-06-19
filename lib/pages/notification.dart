import 'package:flutter/material.dart';
import 'package:hey_joy_application/pages/all_notifications.dart';
import 'package:hey_joy_application/pages/read_notifications.dart';
import 'package:hey_joy_application/pages/unread_notifications.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List _pages = [
    AllNotifications(),
    UnreadNotifications(),
    ReadNotifications()
  ];

  int _selectedIndex = 0;

  void navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Text(''),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Text(''),
            label: 'Unread',
          ),
          BottomNavigationBarItem(
            icon: Text(''),
            label: 'Read',
          ),
        ],
        onTap: navigateToPage,
      ),
      body: SafeArea(
        child: Column(
          children:  [
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Notifications',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Icon(Icons.more_vert_outlined)

              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
