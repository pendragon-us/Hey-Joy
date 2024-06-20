import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hey_joy_application/data/mood_pref.dart';
import 'package:hey_joy_application/data/push_notification.dart';
import 'package:hey_joy_application/notification/notification.dart';
import 'package:hey_joy_application/pages/auth_page.dart';
import 'package:hey_joy_application/pages/calender_page.dart';
import 'package:hey_joy_application/pages/chatbot.dart';
import 'package:hey_joy_application/pages/dashboard.dart';
import 'package:hey_joy_application/pages/emoji_tracker.dart';
import 'package:hey_joy_application/pages/game.dart';
import 'package:hey_joy_application/pages/jornal_or_calaneder.dart';
import 'package:hey_joy_application/pages/journal.dart';
import 'package:hey_joy_application/pages/log_in_page.dart';
import 'package:hey_joy_application/pages/notification.dart';
import 'package:hey_joy_application/pages/sign_up_page.dart';
import 'package:hey_joy_application/pages/user_profile.dart';
import 'data/game_pref.dart';
import 'data/user_pref.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();

//function to listen background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if(message.notification != null){
    print('some notification');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //local notifications service
  await NotificationService.init();
  tz.initializeTimeZones();

  //Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if(message.notification != null){
      navigatorKey.currentState!.pushNamed('/emojiTracker');
    }
  });

  // //Firebase Messaging
  PushNotification.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Hive
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');
  await Hive.openBox('notifications');

  //Shared Preferences
  await UserPref.init();
  await GamePref.init();
  await MoodPref.init();

  //SystemChrome for orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const HeyJoyApp());
  });
}

class HeyJoyApp extends StatelessWidget {
  const HeyJoyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/signUp': (context) =>  SignUpPage(),
        '/logIn': (context) =>  LogInPage(),
        '/userProfile': (context) =>  UserProfilePage(),
        '/dashboard': (context) => Dashboard(),
        '/chatbot': (context) =>  ChatBotPage(),
        '/game': (context) =>  GamePage(),
        '/journal': (context) =>  JournalPage(),
        '/notification': (context) =>  NotificationPage(),
        '/emojiTracker': (context) =>  MoodSelectorPage(),
        '/calender': (context) =>  CalendarPage(),
        '/journalOrCalender': (context) =>  JournalOrCalender(),
      },
      debugShowCheckedModeBanner: false,
      home:  AuthPage(),
    );
  }
}
