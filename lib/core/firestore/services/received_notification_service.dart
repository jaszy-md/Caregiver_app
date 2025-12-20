import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_link/core/firestore/models/received_notification.dart';

class ReceivedNotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  /// ✅ Notificatie opslaan MET patientName
  /// + userName voor backward compatibility
  /// Zo hoeft de UI NOOIT extra Firestore calls te doen
  Future<void> addNotification({
    required String caregiverUid,
    required String patientUid,
    required String patientName,
    required String receivedLabel,
  }) async {
    final cleanName = patientName.trim();

    await _db
        .collection('users')
        .doc(caregiverUid)
        .collection('received_notifications')
        .add({
          'caregiverUid': caregiverUid,
          'patientUid': patientUid,

          // ✅ NIEUW (primair)
          'patientName': cleanName,

          // ✅ BACKWARD COMPAT (voor oude data / oudere code)
          'userName': cleanName,

          'receivedLabel': receivedLabel,
          'createdAt': FieldValue.serverTimestamp(),
        });
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

  /// Verwijder alle notificaties
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
