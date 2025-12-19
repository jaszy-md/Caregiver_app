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

    // Dagelijkse historie
    await _db
        .collection('users')
        .doc(uid)
        .collection('healthStatsDaily')
        .doc(key)
        .set(payload, SetOptions(merge: true));

    // User-root (laatste dag + datum)
    await _db.collection('users').doc(uid).update({
      'healthStats': {
        'eetlust': payload['eetlust'],
        'energie': payload['energie'],
        'stemming': payload['stemming'],
        'slaapritme': payload['slaapritme'],
      },
      'healthStatsDate': key, // ← NIEUW (dag waarop deze stats horen)
      'healthStatsUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchWeekHealthStats(
    String uid,
    DateTime weekStart,
  ) {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(const Duration(days: 7));

    print('==============================');
    print('[UserService] watchWeekHealthStats');
    print('[UserService] uid = $uid');
    print('[UserService] start = $start');
    print('[UserService] end = $end');
    print('==============================');

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
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - DateTime.monday));

    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));

    print('[UserService] calculateWeeklyHealthPercentage uid = $uid');
    print('[UserService] week start = $start');
    print('[UserService] week end = $end');

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

      final energie = (data['energie'] ?? 0) as int;
      final eetlust = (data['eetlust'] ?? 0) as int;
      final stemming = (data['stemming'] ?? 0) as int;
      final slaapritme = (data['slaapritme'] ?? 0) as int;

      totalScore += energie + eetlust + stemming + slaapritme;
      totalPossible += 40;

      print(
        '[UserService] day score = ${energie + eetlust + stemming + slaapritme}/40',
      );
    }

    if (totalPossible == 0) {
      print('[UserService] no data this week → 0%');
      return 0;
    }

    final percentage = ((totalScore / totalPossible) * 100).round();
    print('[UserService] weekly percentage = $percentage%');

    return percentage.clamp(0, 100);
  }

  /// =========================
  /// NOTIFICATIES (CAREGIVER)
  /// =========================

  Future<void> deleteReceivedNotification(
    String caregiverUid,
    String notificationId,
  ) async {
    print(
      '[UserService] deleteReceivedNotification caregiverUid = $caregiverUid notificationId = $notificationId',
    );

    await _db
        .collection('users')
        .doc(caregiverUid)
        .collection('received_notifications')
        .doc(notificationId)
        .delete();
  }

  Future<void> deleteAllReceivedNotifications(String caregiverUid) async {
    print(
      '[UserService] deleteAllReceivedNotifications caregiverUid = $caregiverUid',
    );

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
