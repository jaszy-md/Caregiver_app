import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_link/core/firestore/services/user_link_service.dart';

class CaregiverConnectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserLinkService _linkService = UserLinkService();

  /// Verbind patiënt met mantelzorger via userID code
  Future<String?> connectCaregiverByCode(String patientUid, String code) async {
    code = code.trim().toUpperCase();

    if (code.isEmpty) {
      return "Vul een mantelzorger-ID in.";
    }

    // Zoek gebruiker met deze zichtbare code
    final query =
        await _db
            .collection('users')
            .where('userID', isEqualTo: code)
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      return "Geen mantelzorger gevonden met deze code.";
    }

    final caregiverDoc = query.docs.first;
    final caregiverUid = caregiverDoc.id;

    // Zelf-koppelen voorkomen
    if (caregiverUid == patientUid) {
      return "Je kunt jezelf niet koppelen.";
    }

    // Koppeling uitvoeren
    await _linkService.linkUsers(
      patientUid: patientUid,
      caregiverUid: caregiverUid,
    );

    return null; // Succes
  }

  /// Realtime gekoppelde gebruikers ophalen
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
          d['uid'] = userDoc.id;
          result.add(d);
        }
      }

      return result;
    });
  }
}
