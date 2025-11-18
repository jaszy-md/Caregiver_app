import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String role;
  final String userID;
  final DateTime createdAt;
  final List<String> linkedUserIds;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.userID,
    required this.createdAt,
    required this.linkedUserIds,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      userID: data['userID'] ?? '',
      createdAt: _parseDate(data['createdAt']),
      linkedUserIds: List<String>.from(data['linkedUserIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'userID': userID,
      'createdAt': createdAt,
      'linkedUserIds': linkedUserIds,
    };
  }
}

DateTime _parseDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
