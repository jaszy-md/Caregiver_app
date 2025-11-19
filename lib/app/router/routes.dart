import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// LAYOUT
import 'package:care_link/features/shared/presentation/widgets/layout/main_layout/main_layout.dart';
import 'package:care_link/features/caregiver/presentation/widgets/layout/caregiver_footer.dart';
import 'package:care_link/features/patient/presentation/widgets/layout/patient_footer.dart';
import 'package:care_link/features/caregiver/presentation/widgets/layout/caregiver_sub_header.dart';
import 'package:care_link/features/patient/presentation/widgets/layout/patient_sub_header.dart';

// SCREENS
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

/// Instant transition helper (geen animaties)
CustomTransitionPage instantScreen(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (_, __, ___, child) => child,
  );
}

// Zelfde route-lijsten als je oude setup
final caregiverRoutes = <String>[
  '/caregiverhome',
  '/stats',
  '/caregiverprofile',
  '/caregiver_id',
];

final patientRoutes = <String>[
  '/patienthome',
  '/healthcheck',
  '/patientprofile',
  '/connect',
];

// Onthouden vanaf welke “kant” je in de help-guide komt
String? _lastSection;

/// De globale routes-lijst die AppRouter gebruikt
final appRoutes = <RouteBase>[
  // Splash buiten de Shell
  GoRoute(
    path: '/splash',
    pageBuilder: (context, state) => instantScreen(const SplashScreen()),
  ),

  // Shell met header/footer
  ShellRoute(
    builder: (context, state, child) {
      final uri = state.uri.toString();

      Widget? footer;
      Widget? subHeader;

      // Caregiver routes → caregiver footer + subheader
      if (caregiverRoutes.any((r) => uri.startsWith(r))) {
        _lastSection = 'caregiver';
        footer = const CaregiverFooter();
        subHeader = const CaregiverSubHeader();
      }
      // Patient routes → patient footer + subheader
      else if (patientRoutes.any((r) => uri.startsWith(r))) {
        _lastSection = 'patient';
        footer = const PatientFooter();
        subHeader = const PatientSubHeader();
      }
      // Help-guide krijgt de footer van de laatst bezochte sectie
      else if (uri.startsWith('/help_guide')) {
        if (_lastSection == 'caregiver') {
          footer = const CaregiverFooter();
          subHeader = const CaregiverSubHeader();
        } else if (_lastSection == 'patient') {
          footer = const PatientFooter();
          subHeader = const PatientSubHeader();
        }
      }

      // Login geen header, geen footer
      if (uri.startsWith('/login')) {
        return MainLayout(
          showHeader: false,
          subHeader: null,
          footer: null,
          child: child,
        );
      }

      // Prehome wel header, geen footer
      if (uri.startsWith('/prehome')) {
        return MainLayout(
          showHeader: true,
          subHeader: null,
          footer: null,
          child: child,
        );
      }

      // Alle andere normale layout
      return MainLayout(
        showHeader: true,
        subHeader: subHeader,
        footer: footer,
        child: child,
      );
    },

    routes: [
      // AUTH
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
      GoRoute(
        path: '/stats',
        pageBuilder: (c, s) => instantScreen(const StatsScreen()),
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

      // SHARED
      GoRoute(
        path: '/help_guide',
        pageBuilder: (c, s) => instantScreen(const HelpGuideScreen()),
      ),
    ],
  ),
];
