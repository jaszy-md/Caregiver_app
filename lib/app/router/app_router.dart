import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouter {
  static String? _cachedRole;
  static String? _cachedUid;

  static void clearRoleCache() {
    _cachedRole = null;
    _cachedUid = null;
  }

  static Future<String?> _getUserRole(String uid) async {
    if (_cachedUid == uid && _cachedRole != null) return _cachedRole;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = doc.data()?['role'];

      if (role is String && role.isNotEmpty) {
        _cachedUid = uid;
        _cachedRole = role;
        return role;
      }
    } catch (_) {}

    return null;
  }

  static String _homeForRole(String role) {
    return role == 'caregiver' ? '/caregiverhome' : '/patienthome';
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: appRoutes,

    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;
      final location = state.matchedLocation;

      final loggedIn = user != null;
      final atLogin = location == '/login';
      final atSplash = location == '/splash';
      final atPrehome = location == '/prehome';

      // 🔴 UITGELOGD
      if (!loggedIn) {
        clearRoleCache();
        return atLogin ? null : '/login';
      }

      // 🟡 INGLOGD → rol ophalen
      final role = await _getUserRole(user.uid);

      // Splash afhandelen
      if (atSplash) {
        return role == null ? '/prehome' : _homeForRole(role);
      }

      // Login blokkeren als je al ingelogd bent
      if (atLogin) {
        return role == null ? '/prehome' : _homeForRole(role);
      }

      // Prehome blokkeren als rol al gekozen is
      if (role != null && atPrehome) {
        return _homeForRole(role);
      }

      // Rol bestaat niet → altijd naar prehome
      if (role == null && !atPrehome) {
        return '/prehome';
      }

      return null;
    },
  );
}
