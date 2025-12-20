import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouter {
  static String? _cachedRole;
  static String? _cachedUid;

  // 🔑 SPLASH GATE
  static bool _splashCompleted = false;

  static void markSplashCompleted() {
    _splashCompleted = true;
  }

  static void clearRoleCache() {
    _cachedRole = null;
    _cachedUid = null;
  }

  static Future<String?> _getUserRole(String uid) async {
    if (_cachedUid == uid && _cachedRole != null) return _cachedRole;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final role = doc.data()?['role'];
    if (role is String && role.isNotEmpty) {
      _cachedUid = uid;
      _cachedRole = role;
      return role;
    }

    return null;
  }

  static String _homeForRole(String role) {
    return role == 'caregiver' ? '/caregiverhome' : '/patienthome';
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: appRoutes,

    redirect: (context, state) async {
      final location = state.matchedLocation;
      final user = FirebaseAuth.instance.currentUser;

      final atSplash = location == '/splash';
      final atLogin = location == '/login';
      final atPrehome = location == '/prehome';

      // 🟢 SPLASH MAG ALTIJD EERST ZICHTBAAR ZIJN
      if (atSplash && !_splashCompleted) {
        return null;
      }

      // 🟡 SPLASH KLAAR → ROUTE BESLISSEN
      if (atSplash && _splashCompleted) {
        if (user == null) return '/login';

        final role = await _getUserRole(user.uid);
        return role == null ? '/prehome' : _homeForRole(role);
      }

      // 🔴 UITGELOGD
      if (user == null) {
        clearRoleCache();
        return atLogin ? null : '/login';
      }

      // 🟢 INGLOGD
      final role = await _getUserRole(user.uid);

      if (atLogin) {
        return role == null ? '/prehome' : _homeForRole(role);
      }

      if (role != null && atPrehome) {
        return _homeForRole(role);
      }

      if (role == null && !atPrehome) {
        return '/prehome';
      }

      return null;
    },
  );
}
