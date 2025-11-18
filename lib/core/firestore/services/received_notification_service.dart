import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_link/core/firestore/models/received_notification.dart';

class ReceivedNotificationService {
  final _db = FirebaseFirestore.instance;

  /// Realtime stream van ontvangen notificaties voor één mantelzorger
  Stream<List<ReceivedNotification>> watch(String caregiverUid) {
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

  /// Verwijder één notificatie
  Future<void> deleteNotification({
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

  /// Verwijder alle notificaties (optioneel)
  Future<void> clearAll(String caregiverUid) async {
    final col = _db
        .collection('users')
        .doc(caregiverUid)
        .collection('received_notifications');

    final snap = await col.get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }
}
