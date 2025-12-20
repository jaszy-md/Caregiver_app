import 'package:cloud_firestore/cloud_firestore.dart';

class ReceivedNotification {
  final String id;
  final String caregiverUid;
  final String patientUid;
  final String receivedLabel;
  final DateTime createdAt;
  final String patientName;

  const ReceivedNotification({
    required this.id,
    required this.caregiverUid,
    required this.patientUid,
    required this.receivedLabel,
    required this.createdAt,
    required this.patientName,
  });

  factory ReceivedNotification.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    // ✅ patientName → fallback naar userName → eerste naam pakken
    final rawName =
        (data['patientName'] ?? data['userName'] ?? '').toString().trim();

    final firstName = rawName.isNotEmpty ? rawName.split(' ').first : '';

    // 🔍 DEBUG (mag je later weghalen)
    print('[ReceivedNotification] id=${doc.id}');
    print('[ReceivedNotification] rawName="$rawName"');
    print('[ReceivedNotification] firstName="$firstName"');

    return ReceivedNotification(
      id: doc.id,
      caregiverUid: data['caregiverUid'] as String? ?? '',
      patientUid: data['patientUid'] as String? ?? '',
      receivedLabel: data['receivedLabel'] as String? ?? '',
      createdAt: _parseDate(data['createdAt']),
      patientName: firstName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caregiverUid': caregiverUid,
      'patientUid': patientUid,
      'receivedLabel': receivedLabel,
      'createdAt': Timestamp.fromDate(createdAt),
      'patientName': patientName,
    };
  }
}

DateTime _parseDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
