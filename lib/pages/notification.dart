import 'package:flutter/material.dart';
import 'package:hey_joy_application/pages/read_notifications.dart';
import 'package:hey_joy_application/pages/unread_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../data/user_pref.dart';
import 'all_notifications.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  String selectedImage = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedImage = UserPref.getImage();
    });
  }


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
      appBar: AppBar(
        backgroundColor: Color(0xffD9D9D9),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('images/HeyJoylogo.png', width: 95, height: 95,),
            SizedBox(width: 10,),
            Image.asset(selectedImage, width: 60, height: 60,)
          ],
        ),
      ),
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
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('notifications').listenable(),
                  builder: (context, Box box, widget) {
                    if (box.values.isEmpty) {
                      return Center(
                        child: Text('No notifications'),
                      );
                    }

                    return ListView.builder(
                      itemCount: box.values.length,
                      itemBuilder: (context, index) {
                        var notification = box.getAt(index);
                        return ListTile(
                          title: Text(notification['quote']),
                          subtitle: Text(notification['mood']),
                          trailing: Text(DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(notification['time']))),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
