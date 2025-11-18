import 'package:cloud_firestore/cloud_firestore.dart';

class UserLinkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Koppel patiënt ↔ mantelzorger
  Future<void> linkUsers({
    required String patientUid,
    required String caregiverUid,
  }) async {
    final patientRef = _db.collection('users').doc(patientUid);
    final caregiverRef = _db.collection('users').doc(caregiverUid);

    await _db.runTransaction((txn) async {
      final patientSnap = await txn.get(patientRef);
      final caregiverSnap = await txn.get(caregiverRef);

      if (!patientSnap.exists || !caregiverSnap.exists) return;

      List<dynamic> pLinks = List.from(patientSnap['linkedUserIds'] ?? []);
      List<dynamic> cLinks = List.from(caregiverSnap['linkedUserIds'] ?? []);

      if (!pLinks.contains(caregiverUid)) pLinks.add(caregiverUid);
      if (!cLinks.contains(patientUid)) cLinks.add(patientUid);

      txn.update(patientRef, {'linkedUserIds': pLinks});
      txn.update(caregiverRef, {'linkedUserIds': cLinks});
    });
  }

  /// Ontkoppel patiënt ↔ mantelzorger
  Future<void> unlinkUsers({
    required String patientUid,
    required String caregiverUid,
  }) async {
    final patientRef = _db.collection('users').doc(patientUid);
    final caregiverRef = _db.collection('users').doc(caregiverUid);

    await _db.runTransaction((txn) async {
      final patientSnap = await txn.get(patientRef);
      final caregiverSnap = await txn.get(caregiverRef);

      if (!patientSnap.exists || !caregiverSnap.exists) return;

      List<dynamic> pLinks = List.from(patientSnap['linkedUserIds'] ?? []);
      List<dynamic> cLinks = List.from(caregiverSnap['linkedUserIds'] ?? []);

      pLinks.remove(caregiverUid);
      cLinks.remove(patientUid);

      txn.update(patientRef, {'linkedUserIds': pLinks});
      txn.update(caregiverRef, {'linkedUserIds': cLinks});
    });
  }
}
