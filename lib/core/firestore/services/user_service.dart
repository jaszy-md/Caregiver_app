import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  /// =========================
  /// USER BASIS
  /// =========================

  Future<Map<String, dynamic>?> getUser(String uid) async {
    print('[UserService] getUser uid = $uid');

    final doc = await _db.collection('users').doc(uid).get();

    print('[UserService] getUser exists = ${doc.exists}');
    print('[UserService] getUser data = ${doc.data()}');

    return doc.data();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    print('[UserService] updateUser uid = $uid');
    print('[UserService] updateUser payload = $data');

    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    print('[UserService] createUser uid = $uid');
    print('[UserService] createUser payload = $data');

    await _db.collection('users').doc(uid).set(data);
  }

  Future<void> updateEmergencyContact(String uid, String? phoneNumber) async {
    print(
      '[UserService] updateEmergencyContact uid = $uid phone = $phoneNumber',
    );

    await _db.collection('users').doc(uid).update({
      'emergencyContact': phoneNumber,
    });
  }

  /// =========================
  /// KOPPELING: CAREGIVER → PATIENT
  /// =========================

  Future<String?> findPatientForCaregiver(String caregiverUid) async {
    print('[UserService] findPatientForCaregiver caregiverUid = $caregiverUid');

    final snapshot =
        await _db
            .collection('users')
            .where('role', isEqualTo: 'patient')
            .where('linkedUserIds', arrayContains: caregiverUid)
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) {
      print('[UserService] ❌ no patient found for caregiver');
      return null;
    }

    final patientId = snapshot.docs.first.id;
    print('[UserService] ✅ patient found = $patientId');

    return patientId;
  }

  /// =========================
  /// ACTIEVE PATIËNT (CAREGIVER)
  /// =========================

  Future<void> setActivePatientForCaregiver({
    required String caregiverUid,
    required String patientUid,
  }) async {
    print(
      '[UserService] setActivePatientForCaregiver caregiver=$caregiverUid patient=$patientUid',
    );

    await _db.collection('users').doc(caregiverUid).update({
      'activePatientUid': patientUid,
      'activePatientUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getActivePatientForCaregiver(String caregiverUid) async {
    print('[UserService] getActivePatientForCaregiver caregiver=$caregiverUid');

    final doc = await _db.collection('users').doc(caregiverUid).get();
    final uid = doc.data()?['activePatientUid'];

    return uid is String && uid.isNotEmpty ? uid : null;
  }

  /// =========================
  /// HEALTH STATS
  /// =========================

  String _dayKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  Future<void> saveTodayHealthStats(String uid, Map<String, int> stats) async {
    final now = DateTime.now();
    final key = _dayKey(now);

    final payload = {
      'date': Timestamp.fromDate(DateTime(now.year, now.month, now.day)),
      'eetlust': (stats['Eetlust'] ?? 0).clamp(0, 10),
      'energie': (stats['Energie'] ?? 0).clamp(0, 10),
      'stemming': (stats['Stemming'] ?? 0).clamp(0, 10),
      'slaapritme': (stats['Slaapritme'] ?? 0).clamp(0, 10),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    print('[UserService] saveTodayHealthStats uid = $uid');
    print('[UserService] saveTodayHealthStats key = $key');
    print('[UserService] saveTodayHealthStats payload = $payload');

    await _db
        .collection('users')
        .doc(uid)
        .collection('healthStatsDaily')
        .doc(key)
        .set(payload, SetOptions(merge: true));

    await _db.collection('users').doc(uid).update({
      'healthStats': {
        'eetlust': payload['eetlust'],
        'energie': payload['energie'],
        'stemming': payload['stemming'],
        'slaapritme': payload['slaapritme'],
      },
      'healthStatsDate': key,
      'healthStatsUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchWeekHealthStats(
    String uid,
    DateTime weekStart,
  ) {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(const Duration(days: 7));

    print('[UserService] watchWeekHealthStats uid = $uid');

    return _db
        .collection('users')
        .doc(uid)
        .collection('healthStatsDaily')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date')
        .snapshots();
  }

  /// =========================
  /// WEEKLY STATUS (%)
  /// =========================

  Future<int> calculateWeeklyHealthPercentage(String uid) async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - DateTime.monday));

    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));

    print('[UserService] calculateWeeklyHealthPercentage uid = $uid');

    final snapshot =
        await _db
            .collection('users')
            .doc(uid)
            .collection('healthStatsDaily')
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
            .where('date', isLessThan: Timestamp.fromDate(end))
            .get();

    int totalScore = 0;
    int totalPossible = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final energie = (data['energie'] as num?)?.toInt() ?? 0;
      final eetlust = (data['eetlust'] as num?)?.toInt() ?? 0;
      final stemming = (data['stemming'] as num?)?.toInt() ?? 0;
      final slaapritme = (data['slaapritme'] as num?)?.toInt() ?? 0;

      totalScore += energie + eetlust + stemming + slaapritme;
      totalPossible += 40;
    }

    if (totalPossible == 0) return 0;

    return ((totalScore / totalPossible) * 100).round().clamp(0, 100);
  }

  /// =========================
  /// NOTIFICATIES (CAREGIVER)
  /// =========================

  Future<void> deleteReceivedNotification(
    String caregiverUid,
    String notificationId,
  ) async {
    await _db
        .collection('users')
        .doc(caregiverUid)
        .collection('received_notifications')
        .doc(notificationId)
        .delete();
  }

  Future<void> deleteAllReceivedNotifications(String caregiverUid) async {
    final snapshot =
        await _db
            .collection('users')
            .doc(caregiverUid)
            .collection('received_notifications')
            .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
