import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/core/firestore/models/received_notification.dart';
import 'package:care_link/core/firestore/services/received_notification_service.dart';

/// Service provider
final receivedNotificationServiceProvider =
    Provider<ReceivedNotificationService>((ref) {
      return ReceivedNotificationService();
    });

/// Stream van notificaties per caregiverUid
final receivedNotificationsProvider =
    StreamProvider.family<List<ReceivedNotification>, String>((
      ref,
      caregiverUid,
    ) {
      // 🔥 CRUCIAAL: Firestore stream warm houden
      ref.keepAlive();

      return ref.read(receivedNotificationServiceProvider).watch(caregiverUid);
    });
