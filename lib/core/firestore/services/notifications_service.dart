import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_link/core/firestore/models/notification_item.dart';
import 'package:care_link/core/firestore/models/received_notification.dart';

class NotificationsService {
  final _db = FirebaseFirestore.instance;

  Stream<List<ReceivedNotification>> watchReceivedNotifications(
    String caregiverUid,
  ) {
    return _db
        .collection('users')
        .doc(caregiverUid)
        .collection('received_notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((doc) => ReceivedNotification.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<List<NotificationItem>> fetchNotificationBlocks() async {
    final snap = await _db.collection('notifications').orderBy('order').get();

    return snap.docs
        .map((doc) => NotificationItem.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> sendNotificationToLinkedCaregivers({
    required String patientUid,
    required String patientName,
    required String label,
  }) async {
    final userDoc = await _db.collection('users').doc(patientUid).get();
    if (!userDoc.exists) return;

    final data = userDoc.data()!;
    final linkedIds = List<String>.from(data['linkedUserIds'] ?? []);

    for (final caregiverUid in linkedIds) {
      await _db
          .collection('users')
          .doc(caregiverUid)
          .collection('received_notifications')
          .add({
            'caregiverUid': caregiverUid,
            'patientUid': patientUid,
            'receivedLabel': label,
            'createdAt': FieldValue.serverTimestamp(),
            'userName': patientName,
          });
    }
  }

  Future<void> deleteReceivedNotification({
    required String caregiverUid,
    required String notificationId,
  }) {
    return _db
        .collection('users')
        .doc(caregiverUid)
        .collection('received_notifications')
        .doc(notificationId)
        .delete();
  }
}
