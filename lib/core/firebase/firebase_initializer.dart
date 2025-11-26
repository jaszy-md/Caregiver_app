import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

class FirebaseInitializer {
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'carelink_alerts',
      'CareLink Alerts',
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await FirebaseMessaging.instance.requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    print('FCM token: $token');

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        "fcmToken": token,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    FirebaseMessaging.onMessage.listen((message) {
      print('ON MESSAGE RECEIVED: ${message.notification?.title}');
      _showLocalNotification(message);
    });
  }

  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('BACKGROUND MESSAGE: ${message.messageId}');
  }

  static void _showLocalNotification(RemoteMessage message) {
    _local.show(
      0,
      message.notification?.title ?? 'CareLink Alert',
      message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'carelink_alerts',
          'CareLink Alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
