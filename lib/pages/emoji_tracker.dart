import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../notification/notification.dart';

class MoodSelectorPage extends StatefulWidget {
  const MoodSelectorPage({super.key});

  @override
  _MoodSelectorPageState createState() => _MoodSelectorPageState();
}

class _MoodSelectorPageState extends State<MoodSelectorPage> {
  int selectedIndex = 2; // Default value
  String formattedDate = DateFormat('EEE, d MMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
    tz.initializeTimeZones();
  }

  // Send notification to user
  void sendNotificationBasedOnMood() async {
    // Map the selected index to mood names
    final moodMap = {
      0: 'angry',
      1: 'sad',
      2: 'neutral',
      3: 'happy',
      4: 'loving',
      5: 'depressed',
      6: 'anxious',
      7: 'stressed',
    };

    // Get the mood based on the selected index
    String mood = moodMap[selectedIndex] ?? 'neutral';

    // Fetch quotes from Firestore based on the mood
    List<String> quotes = await fetchQuotesFromFirestore(mood);
    print('Fetched quotes: $quotes');

    if (quotes.isNotEmpty) {
      // Load recently used indices
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<int> usedIndices = prefs.getStringList('usedIndices_$mood')?.map((e) => int.parse(e)).toList() ?? [];

      // Get a list of unused indices
      List<int> availableIndices = List.generate(quotes.length, (index) => index)
          .where((index) => !usedIndices.contains(index))
          .toList();

      // If all quotes have been used, reset the usedIndices list
      if (availableIndices.isEmpty) {
        usedIndices.clear();
        availableIndices = List.generate(quotes.length, (index) => index);
      }

      // Randomly select an available index
      int randomIndex = availableIndices[Random().nextInt(availableIndices.length)];
      String randomQuote = quotes[randomIndex];
      print('Selected quote: $randomQuote');

      // Update the used indices list
      usedIndices.add(randomIndex);
      await prefs.setStringList('usedIndices_$mood', usedIndices.map((e) => e.toString()).toList());

      // Schedule the notification
      DateTime scheduleTime = DateTime.now().add(Duration(seconds: 10));
      NotificationService.showScheduleNotificationForQuotes(mood, randomQuote, scheduleTime);
      print('Scheduled notification for $scheduleTime');

      // Save notification to Hive
      var box = Hive.box('notifications');
      await box.add({'mood': mood, 'quote': randomQuote, 'time': scheduleTime.toIso8601String()});

      print('Notification saved to Hive');

    } else {
      print('No quotes available for mood: $mood');
    }
  }

  Future<List<String>> fetchQuotesFromFirestore(String mood) async {
    List<String> quotes = [];
    try {
      // Reference the document for the specified mood
      DocumentReference<Map<String, dynamic>> docRef =
      FirebaseFirestore.instance.collection('quotes').doc(mood);

      // Fetch the document snapshot
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await docRef.get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();

        // Extract quotes
        quotes = List<String>.from(data?['quotes'] ?? []);

        // Log fetched quotes
        print('Quotes for mood $mood: $quotes');
      } else {
        print('Document with mood "$mood" does not exist.');
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    }
    return quotes;
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
                            }
                            _saveSelectedIndex(selectedIndex); // Save the index
                            sendNotificationBasedOnMood(); // Send notification on emoji tap
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
