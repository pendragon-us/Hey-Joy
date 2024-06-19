import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification{
  static final _firebaseMessaging = FirebaseMessaging.instance;

  //request permission
  static Future init() async{
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //get device token
    final token = await _firebaseMessaging.getToken();
    print('Token: $token');
  }
}
