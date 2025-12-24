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

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Android notification channel
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

    // Android 13+ permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground notification behavior
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Get initial token
    final token = await FirebaseMessaging.instance.getToken();
    print('FCM token: $token');

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // 🔑 LISTEN FOR TOKEN REFRESH
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'fcmToken': newToken, 'updatedAt': FieldValue.serverTimestamp()},
      );

      print('FCM token refreshed: $newToken');
    });

    // Foreground message handling
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
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    _local.show(
      notificationId,
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
