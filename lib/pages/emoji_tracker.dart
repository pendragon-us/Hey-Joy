import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MoodSelectorPage extends StatefulWidget {
  const MoodSelectorPage({super.key});

  @override
  _MoodSelectorPageState createState() => _MoodSelectorPageState();
}

class _MoodSelectorPageState extends State<MoodSelectorPage> {
  int selectedIndex = 2; // Default value
  String formattedDate = DateFormat('EEE, d MMM').format(DateTime.now());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  List<String> quotes = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
    _initializeNotification();
    tz.initializeTimeZones();
  }

  // Load the selected emoji index from shared preferences
  _loadSelectedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selectedIndex') ?? 2; // Default to 2 if not set
    });
  }

  // Save the selected emoji index to shared preferences
  _saveSelectedIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', index);
    prefs.setStringList('quotes', quotes);
  }

  // Fetch quotes from Firestore based on mood
  Future<void> fetchQuotes(String mood) async {
    try {
      var snapshot = await _firestore.collection('Quotes').doc(mood.toLowerCase()).get();
      var data = snapshot.data();
      if (data != null) {
        setState(() {
          quotes = List.from(data['quotes']);
        });
        // Save quotes to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setStringList('quotes', quotes);
        print('Quotes: $quotes');
      } else {
        setState(() {
          quotes = []; // Clear quotes if data is null
        });
      }
    } catch (e) {
      print('Error fetching quotes: $e');
      setState(() {
        quotes = []; // Clear quotes on error
      });
    }
  }

  // Initialize notification settings
  Future<void> _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Schedule hourly notifications
  Future<void> scheduleNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> quotes = prefs.getStringList('quotes') ?? [];

    if (quotes.isEmpty) return;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Cancel all existing notifications
    await flutterLocalNotificationsPlugin.cancelAll();

    for (int i = 1; i <= 24; i++) { // Schedule for the next 24 hours
      await flutterLocalNotificationsPlugin.zonedSchedule(
          i,
          'Motivational Quote',
          quotes[Random().nextInt(quotes.length)], // Select a random quote
          tz.TZDateTime.now(tz.local).add(Duration(minutes: i)),
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Color(0xffe0eaef), Color(0xffd8def6), Color(0xfff5f5f9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row with date and page indicator
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Text(formattedDate, style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.calendar_month_outlined,
                                  size: 20, color: Color(0xff8b4cfc)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      "What's your mood now?",
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Select mood that reflects the most how you are\nfeeling at this moment.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
                // Emoji row
                SizedBox(
                  height: 150, // Adjust the height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: emojis.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedIndex == index) {
                              selectedIndex = -1; // Deselect if the same emoji is tapped
                            } else {
                              selectedIndex = index;
                              String selectedMood = emotionNames[index];
                              fetchQuotes(selectedMood); // Fetch quotes for selected mood
                            }
                            _saveSelectedIndex(selectedIndex); // Save the index
                            scheduleNotification(); // Schedule notifications
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: selectedIndex == index
                                  ? Color(0xfffed550)
                                  : Colors.white,
                              child: Text(
                                emojis[index],
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              emotionNames[index],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Continue button
                GestureDetector(
                  onTap: () {
                    _saveSelectedIndex(selectedIndex); // Save selected index when continue button is pressed
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xff8b4cfc),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sample emojis and their labels
  final List<String> emojis = [
    '😡',
    '😞',
    '😐',
    '😊',
    '😍',
    '😓',
    '😰',
    '😪'
  ];
  final List<String> emotionNames = [
    'Angry',
    'Sad',
    'Neutral',
    'Happy',
    'Loving',
    'Depressed',
    'Anxious',
    'Stressed'
  ];
}
