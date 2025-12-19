import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/features/shared/presentation/widgets/layout/main_layout/main_layout.dart';
import 'package:care_link/features/caregiver/presentation/widgets/layout/caregiver_footer.dart';
import 'package:care_link/features/patient/presentation/widgets/layout/patient_footer.dart';
import 'package:care_link/features/caregiver/presentation/widgets/layout/caregiver_sub_header.dart';
import 'package:care_link/features/patient/presentation/widgets/layout/patient_sub_header.dart';
import 'package:care_link/features/splash/presentation/screens/splash_screen.dart';
import 'package:care_link/features/auth/presentation/screens/login_screen.dart';
import 'package:care_link/features/prehome/presentation/screens/prehome_screen.dart';
import 'package:care_link/features/caregiver/presentation/screens/home/caregiver_home_screen.dart';
import 'package:care_link/features/caregiver/presentation/screens/profile/caregiver_profile_screen.dart';
import 'package:care_link/features/caregiver/presentation/screens/caregiver_id/caregiver_id_screen.dart';
import 'package:care_link/features/patient/presentation/screens/home/patient_home_screen.dart';
import 'package:care_link/features/patient/presentation/screens/profile/patient_profile_screen.dart';
import 'package:care_link/features/patient/presentation/screens/healthcheck/healthcheck_screen.dart';
import 'package:care_link/features/patient/presentation/screens/connect/connect_screen.dart';
import 'package:care_link/features/shared/presentation/screens/stats/stats_screen.dart';
import 'package:care_link/features/shared/presentation/screens/help_guide/help_guide_screen.dart';

CustomTransitionPage instantScreen(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (_, __, ___, child) => child,
  );
}

final caregiverRoutes = <String>[
  '/caregiverhome',
  '/caregiverprofile',
  '/caregiver_id',
];

final patientRoutes = <String>[
  '/patienthome',
  '/healthcheck',
  '/patientprofile',
  '/connect',
];

String? _lastSection;

final appRoutes = <RouteBase>[
  GoRoute(
    path: '/splash',
    pageBuilder: (context, state) => instantScreen(const SplashScreen()),
  ),

  ShellRoute(
    builder: (context, state, child) {
      final uri = state.uri.toString();

      Widget? footer;
      Widget? subHeader;

      if (caregiverRoutes.any((r) => uri.startsWith(r))) {
        _lastSection = 'caregiver';
      } else if (patientRoutes.any((r) => uri.startsWith(r))) {
        _lastSection = 'patient';
      }

      if (_lastSection == 'caregiver') {
        footer = const CaregiverFooter();
        subHeader = const CaregiverSubHeader();
      } else if (_lastSection == 'patient') {
        footer = const PatientFooter();
        subHeader = const PatientSubHeader();
      }

      if (uri.startsWith('/login')) {
        return MainLayout(
          showHeader: false,
          subHeader: null,
          footer: null,
          child: child,
        );
      }

      if (uri.startsWith('/prehome')) {
        return MainLayout(
          showHeader: true,
          subHeader: null,
          footer: null,
          child: child,
        );
      }

      return MainLayout(
        showHeader: true,
        subHeader: subHeader,
        footer: footer,
        child: child,
      );
    },

    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (c, s) => instantScreen(const LoginScreen()),
      ),
      GoRoute(
        path: '/prehome',
        pageBuilder: (c, s) => instantScreen(const PrehomeScreen()),
      ),

      // CAREGIVER
      GoRoute(
        path: '/caregiverhome',
        pageBuilder: (c, s) => instantScreen(const CaregiverHomeScreen()),
      ),
      GoRoute(
        path: '/caregiverprofile',
        pageBuilder: (c, s) => instantScreen(const CaregiverProfileScreen()),
      ),
      GoRoute(
        path: '/caregiver_id',
        pageBuilder: (c, s) => instantScreen(const CaregiverIdScreen()),
      ),

      // PATIENT
      GoRoute(
        path: '/patienthome',
        pageBuilder: (c, s) => instantScreen(const PatientHomeScreen()),
      ),
      GoRoute(
        path: '/healthcheck',
        pageBuilder: (c, s) => instantScreen(const HealthCheckScreen()),
      ),
      GoRoute(
        path: '/patientprofile',
        pageBuilder: (c, s) => instantScreen(const PatientProfileScreen()),
      ),
      GoRoute(
        path: '/connect',
        pageBuilder: (c, s) => instantScreen(const ConnectScreen()),
      ),

      GoRoute(
        path: '/stats',
        pageBuilder: (c, s) => instantScreen(const StatsScreen()),
      ),
      GoRoute(
        path: '/help_guide',
        pageBuilder: (c, s) => instantScreen(const HelpGuideScreen()),
      ),
    ],
  ),
];
