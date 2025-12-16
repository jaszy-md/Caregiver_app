import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  /// Haal gebruiker op
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  /// Updaten van user-data
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  /// Aanmaken van user-document (bij eerste login)
  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data);
  }

  Future<void> updateEmergencyContact(String uid, String? phoneNumber) async {
    await _db.collection('users').doc(uid).update({
      'emergencyContact': phoneNumber,
    });
  }
}
