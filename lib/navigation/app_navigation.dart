import 'package:care_link/layout/footers/caregiver_footer.dart';
import 'package:care_link/layout/footers/patient_footer.dart';
import 'package:care_link/layout/main_layout/main_layout.dart';
import 'package:care_link/layout/subheaders/caregiver_sub_header.dart';
import 'package:care_link/layout/subheaders/patient_sub_header.dart';
import 'package:care_link/views/caregiver/home/caregiver_home_page.dart';
import 'package:care_link/views/caregiver/profile/caregiver_profile_page.dart';
import 'package:care_link/views/caregiver/stats/caregiver_stats_page.dart';
import 'package:care_link/views/login/login_page.dart';
import 'package:care_link/views/patient/healthcheck/healthcheck_page.dart';
import 'package:care_link/views/patient/home/patient_home_page.dart';
import 'package:care_link/views/patient/profile/patient_profile_page.dart';
import 'package:care_link/views/prehome/prehome_page.dart';
import 'package:care_link/views/splash/splash_page.dart';
import 'package:care_link/views/subviews/caregiver/caregiver_id_page.dart';
import 'package:care_link/views/subviews/patient/connect_page.dart';
import 'package:care_link/views/subviews/shared_view/help_guide_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  AppNavigation._();

  static String? _lastSection;

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash outside shell
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _instantPage(const SplashPage()),
      ),

      // shared shell for the rest
      ShellRoute(
        builder: (context, state, child) {
          final uri = state.uri.toString();

          Widget? footer;
          Widget? subHeader;

          const caregiverRoutes = [
            '/caregiverhome',
            '/stats',
            '/caregiverprofile',
            '/caregiver_id',
          ];
          const patientRoutes = [
            '/patienthome',
            '/healthcheck',
            '/patientprofile',
            '/connect',
          ];

          if (caregiverRoutes.any((r) => uri.startsWith(r))) {
            _lastSection = 'caregiver';
            footer = const CaregiverFooter();
            subHeader = const CaregiverSubHeader();
          } else if (patientRoutes.any((r) => uri.startsWith(r))) {
            _lastSection = 'patient';
            footer = const PatientFooter();
            subHeader = const PatientSubHeader();
          } else if (uri.startsWith('/help_guide')) {
            if (_lastSection == 'caregiver') {
              footer = const CaregiverFooter();
              subHeader = const CaregiverSubHeader();
            } else if (_lastSection == 'patient') {
              footer = const PatientFooter();
              subHeader = const PatientSubHeader();
            }
          }

          final isLogin = uri.startsWith('/login');
          final isPrehome = uri.startsWith('/prehome');

          // Login no header/footer
          if (isLogin) {
            return MainLayout(
              showHeader: false,
              subHeader: null,
              footer: null,
              child: child,
            );
          }

          // Prehome header, nofooter
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
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) => _instantPage(const LoginPage()),
          ),
          GoRoute(
            path: '/prehome',
            pageBuilder: (context, state) => _instantPage(const PrehomePage()),
          ),

          // Caregiver
          GoRoute(
            path: '/caregiverhome',
            pageBuilder: (c, s) => _instantPage(const CaregiverHomePage()),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (c, s) => _instantPage(const CaregiverStatsPage()),
          ),
          GoRoute(
            path: '/caregiverprofile',
            pageBuilder: (c, s) => _instantPage(const CaregiverProfilePage()),
          ),
          GoRoute(
            path: '/caregiver_id',
            pageBuilder: (c, s) => _instantPage(const CaregiverIdPage()),
          ),

          // Patient
          GoRoute(
            path: '/patienthome',
            pageBuilder: (c, s) => _instantPage(const PatientHomePage()),
          ),
          GoRoute(
            path: '/healthcheck',
            pageBuilder: (c, s) => _instantPage(const HealthCheckPage()),
          ),
          GoRoute(
            path: '/patientprofile',
            pageBuilder: (c, s) => _instantPage(const PatientProfilePage()),
          ),
          GoRoute(
            path: '/connect',
            pageBuilder: (c, s) => _instantPage(const ConnectPage()),
          ),

          // Shared
          GoRoute(
            path: '/help_guide',
            pageBuilder: (c, s) => _instantPage(const HelpGuidePage()),
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage _instantPage(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (_, __, ___, child) => child,
    );
  }
}
