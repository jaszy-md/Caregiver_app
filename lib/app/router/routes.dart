import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Layout (nog oude structuur)
import 'package:care_link/layout/main_layout/main_layout.dart';
import 'package:care_link/layout/footers/caregiver_footer.dart';
import 'package:care_link/layout/footers/patient_footer.dart';
import 'package:care_link/layout/subheaders/caregiver_sub_header.dart';
import 'package:care_link/layout/subheaders/patient_sub_header.dart';

// Views (nog oude structuur)
import 'package:care_link/views/splash/splash_page.dart';
import 'package:care_link/views/prehome/prehome_page.dart';
import 'package:care_link/views/login/login_page.dart';

import 'package:care_link/views/caregiver/home/caregiver_home_page.dart';
import 'package:care_link/views/caregiver/profile/caregiver_profile_page.dart';
import 'package:care_link/views/caregiver/stats/caregiver_stats_page.dart';
import 'package:care_link/views/subviews/caregiver/caregiver_id_page.dart';

import 'package:care_link/views/patient/home/patient_home_page.dart';
import 'package:care_link/views/patient/profile/patient_profile_page.dart';
import 'package:care_link/views/patient/healthcheck/healthcheck_page.dart';
import 'package:care_link/views/subviews/patient/connect_page.dart';

import 'package:care_link/views/subviews/shared_view/help_guide_page.dart';

// Oude helper uit AppNavigation
CustomTransitionPage instantPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (_, __, ___, child) => child,
  );
}

// Route-groepen zoals in jouw originele code
final caregiverRoutes = [
  '/caregiverhome',
  '/stats',
  '/caregiverprofile',
  '/caregiver_id',
];

final patientRoutes = [
  '/patienthome',
  '/healthcheck',
  '/patientprofile',
  '/connect',
];

// De volledige routes-lijst die AppRouter gaat gebruiken
final appRoutes = <RouteBase>[
  // Splash buiten de shell
  GoRoute(
    path: '/splash',
    pageBuilder: (context, state) => instantPage(const SplashPage()),
  ),

  // Shell route voor alle andere schermen
  ShellRoute(
    builder: (context, state, child) {
      final uri = state.uri.toString();

      Widget? footer;
      Widget? subHeader;

      if (caregiverRoutes.any((r) => uri.startsWith(r))) {
        footer = const CaregiverFooter();
        subHeader = const CaregiverSubHeader();
      } else if (patientRoutes.any((r) => uri.startsWith(r))) {
        footer = const PatientFooter();
        subHeader = const PatientSubHeader();
      }

      final isLogin = uri.startsWith('/login');
      final isPrehome = uri.startsWith('/prehome');

      if (isLogin) {
        return MainLayout(
          showHeader: false,
          subHeader: null,
          footer: null,
          child: child,
        );
      }

      if (isPrehome) {
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
      // Auth
      GoRoute(
        path: '/login',
        pageBuilder: (c, s) => instantPage(const LoginPage()),
      ),

      // Prehome
      GoRoute(
        path: '/prehome',
        pageBuilder: (c, s) => instantPage(const PrehomePage()),
      ),

      // Caregiver
      GoRoute(
        path: '/caregiverhome',
        pageBuilder: (c, s) => instantPage(const CaregiverHomePage()),
      ),
      GoRoute(
        path: '/stats',
        pageBuilder: (c, s) => instantPage(const CaregiverStatsPage()),
      ),
      GoRoute(
        path: '/caregiverprofile',
        pageBuilder: (c, s) => instantPage(const CaregiverProfilePage()),
      ),
      GoRoute(
        path: '/caregiver_id',
        pageBuilder: (c, s) => instantPage(const CaregiverIdPage()),
      ),

      // Patient
      GoRoute(
        path: '/patienthome',
        pageBuilder: (c, s) => instantPage(const PatientHomePage()),
      ),
      GoRoute(
        path: '/healthcheck',
        pageBuilder: (c, s) => instantPage(const HealthCheckPage()),
      ),
      GoRoute(
        path: '/patientprofile',
        pageBuilder: (c, s) => instantPage(const PatientProfilePage()),
      ),
      GoRoute(
        path: '/connect',
        pageBuilder: (c, s) => instantPage(const ConnectPage()),
      ),

      // Shared
      GoRoute(
        path: '/help_guide',
        pageBuilder: (c, s) => instantPage(const HelpGuidePage()),
      ),
    ],
  ),
];
