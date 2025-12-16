import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_link/core/firestore/services/user_link_service.dart';

class CaregiverConnectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserLinkService _linkService = UserLinkService();

  Future<String?> connectCaregiverByCode(String patientUid, String code) async {
    code = code.trim().toUpperCase();

    if (code.isEmpty) {
      return "Vul een mantelzorger-ID in.";
    }

    final query =
        await _db
            .collection('users')
            .where('userID', isEqualTo: code)
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      return "Geen mantelzorger gevonden met deze code.";
    }

    final caregiverUid = query.docs.first.id;

    if (caregiverUid == patientUid) {
      return "Je kunt jezelf niet koppelen.";
    }

    await _linkService.linkUsers(
      patientUid: patientUid,
      caregiverUid: caregiverUid,
    );

    return null;
  }

  Future<void> disconnectCaregiver({
    required String patientUid,
    required String caregiverUid,
  }) async {
    await _linkService.unlinkUsers(
      patientUid: patientUid,
      caregiverUid: caregiverUid,
    );
  }

  Stream<List<Map<String, dynamic>>> watchLinkedUsers(String uid) {
    return _db.collection('users').doc(uid).snapshots().asyncMap((snap) async {
      final data = snap.data();
      if (data == null) return [];

      final linkedIds = List<String>.from(data['linkedUserIds'] ?? []);
      if (linkedIds.isEmpty) return [];

      final result = <Map<String, dynamic>>[];

      for (final id in linkedIds) {
        final userDoc = await _db.collection('users').doc(id).get();
        if (userDoc.exists) {
          final d = userDoc.data()!;
          d['uid'] = id;
          result.add(d);
        }
      }

      return result;
    });
  }
}
