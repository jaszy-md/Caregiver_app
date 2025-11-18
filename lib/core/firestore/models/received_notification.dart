import 'package:cloud_firestore/cloud_firestore.dart';

class ReceivedNotification {
  final String id;
  final String caregiverUid;
  final String patientUid;
  final String receivedLabel;
  final DateTime createdAt;
  final String userName;

  const ReceivedNotification({
    required this.id,
    required this.caregiverUid,
    required this.patientUid,
    required this.receivedLabel,
    required this.createdAt,
    required this.userName,
  });

  /// Maak model vanuit Firestore document
  factory ReceivedNotification.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return ReceivedNotification(
      id: doc.id,
      caregiverUid: data['caregiverUid'] as String? ?? '',
      patientUid: data['patientUid'] as String? ?? '',
      receivedLabel: data['receivedLabel'] as String? ?? '',
      createdAt: _parseDate(data['createdAt']),
      userName: data['userName'] as String? ?? '',
    );
  }

  /// Voor opslaan in Firestore
  Map<String, dynamic> toMap() {
    return {
      'caregiverUid': caregiverUid,
      'patientUid': patientUid,
      'receivedLabel': receivedLabel,
      'createdAt': Timestamp.fromDate(createdAt),
      'userName': userName,
    };
  }
}

DateTime _parseDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
