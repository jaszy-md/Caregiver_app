import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// UserService singleton via Riverpod
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// FirebaseAuth user (login status)
final firebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Volledige user Firestore document (realtime)
final userDocProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.data());
});

/// Rol opslaan voor een user
final setUserRoleProvider = FutureProvider.family<void, String>((
  ref,
  role,
) async {
  final authUser = FirebaseAuth.instance.currentUser;
  if (authUser == null) return;

  final service = ref.read(userServiceProvider);

  // Kleine safety-check zodat alleen geldige rollen worden opgeslagen
  if (role != 'patient' && role != 'caregiver') {
    throw Exception('Invalid role: $role');
  }

  await service.updateUser(authUser.uid, {
    'role': role,
    'updatedAt': DateTime.now(),
  });
});
