import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'calender_page.dart';
import 'journal.dart';

class JournalOrCalender extends StatefulWidget {
  const JournalOrCalender({super.key});

  @override
  State<JournalOrCalender> createState() => _JournalOrCalenderState();
}

class _JournalOrCalenderState extends State<JournalOrCalender> {
  final List _pages = [
    JournalPage(),
    CalendarPage(),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color(0xff735bf2),
        items: const [
          Icon(Icons.edit_note_outlined, size: 30, color: Colors.white,),
          Icon(Icons.home, size: 30, color: Colors.white,),
        ],
        onTap: (index) {
          navigateToPage(index);
        },
      ),
    );
  }
}
