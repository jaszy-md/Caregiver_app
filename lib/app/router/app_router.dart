import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouter {
  static String? _cachedRole;
  static String? _cachedUid;

  static Future<String?> _getUserRole(String uid) async {
    if (_cachedUid == uid && _cachedRole != null) return _cachedRole;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = doc.data()?['role'];

      if (role is String && role.trim().isNotEmpty) {
        _cachedUid = uid;
        _cachedRole = role.trim();
        return _cachedRole;
      }
    } catch (_) {}

    return null;
  }

  static String _homeForRole(String role) {
    // Pas aan als jouw routes anders heten
    if (role == 'caregiver') return '/caregiverhome';
    return '/patienthome';
  }

  static void clearRoleCache() {
    _cachedRole = null;
    _cachedUid = null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: appRoutes,

    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;
      final location = state.matchedLocation;

      final isLoggedIn = user != null;
      final isAtSplash = location == '/splash';
      final isAtLogin = location == '/login';
      final isAtPrehome = location == '/prehome';

      // Niet ingelogd: alles naar login (behalve login zelf)
      if (!isLoggedIn) {
        clearRoleCache();
        return isAtLogin ? null : '/login';
      }

      // Ingelogd: rol ophalen (of null als nog niet gezet)
      final role = await _getUserRole(user!.uid);

      // Splash: direct doorsturen
      if (isAtSplash) {
        return role == null ? '/prehome' : _homeForRole(role);
      }

      // Ingelogd en op login: blokkeren
      if (isAtLogin) {
        return role == null ? '/prehome' : _homeForRole(role);
      }

      // Rol bestaat: prehome blokkeren
      if (role != null && isAtPrehome) {
        return _homeForRole(role);
      }

      // Rol bestaat: optioneel route-guard per rol (voorkomt "patient" die caregiver routes opent)
      if (role != null) {
        final isCaregiver = role == 'caregiver';
        final isOnCaregiverRoute = location.startsWith('/caregiver');
        final isOnPatientRoute =
            location.startsWith('/patient') ||
            location == '/healthcheck' ||
            location == '/connect';

        if (isCaregiver && isOnPatientRoute) return '/caregiverhome';
        if (!isCaregiver && isOnCaregiverRoute) return '/patienthome';
      }

      // Rol bestaat niet: forceer prehome (behalve als je al op prehome zit)
      if (role == null && !isAtPrehome) {
        return '/prehome';
      }

      return null;
    },
  );
}
