import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final firebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userDocProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.data());
});

// FIXED VERSION
final setUserRoleProvider = FutureProvider.family<void, String>((
  ref,
  role,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final service = ref.read(userServiceProvider);

  await service.updateUser(user.uid, {
    'role': role,
    'updatedAt': FieldValue.serverTimestamp(),
  });
});
