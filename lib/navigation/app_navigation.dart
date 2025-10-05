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
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _instantPage(const SplashPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _instantPage(const LoginPage()),
      ),

      // Alle routes met layout
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

          // Caregiver sectie
          if (caregiverRoutes.any((r) => uri.startsWith(r))) {
            _lastSection = 'caregiver';
            footer = const CaregiverFooter();

            // Subheader alléén tonen op caregiverhome
            if (uri.startsWith('/caregiverhome')) {
              subHeader = const CaregiverSubHeader();
            }
          }
          // Patient sectie
          else if (patientRoutes.any((r) => uri.startsWith(r))) {
            _lastSection = 'patient';
            footer = const PatientFooter();

            // Subheader alléén tonen op patienthome
            if (uri.startsWith('/patienthome')) {
              subHeader = const PatientSubHeader();
            }
          }
          // Shared (hulpgids)
          else if (uri.startsWith('/help_guide')) {
            if (_lastSection == 'caregiver') {
              footer = const CaregiverFooter();
            } else if (_lastSection == 'patient') {
              footer = const PatientFooter();
            }
          }

          return MainLayout(footer: footer, subHeader: subHeader, child: child);
        },
        routes: [
          // Prehome met header=false
          GoRoute(
            path: '/prehome',
            pageBuilder:
                (context, state) => _instantPage(
                  const MainLayout(showHeader: false, child: PrehomePage()),
                ),
          ),

          // Caregiver
          GoRoute(
            path: '/caregiverhome',
            pageBuilder:
                (context, state) => _instantPage(const CaregiverHomePage()),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder:
                (context, state) => _instantPage(const CaregiverStatsPage()),
          ),
          GoRoute(
            path: '/caregiverprofile',
            pageBuilder:
                (context, state) => _instantPage(const CaregiverProlfilePage()),
          ),
          GoRoute(
            path: '/caregiver_id',
            pageBuilder:
                (context, state) => _instantPage(const CaregiverIdPage()),
          ),

          // Patient
          GoRoute(
            path: '/patienthome',
            pageBuilder:
                (context, state) => _instantPage(const PatientHomePage()),
          ),
          GoRoute(
            path: '/healthcheck',
            pageBuilder:
                (context, state) => _instantPage(const HealthCheckPage()),
          ),
          GoRoute(
            path: '/patientprofile',
            pageBuilder:
                (context, state) => _instantPage(const PatientProfilePage()),
          ),
          GoRoute(
            path: '/connect',
            pageBuilder: (context, state) => _instantPage(const ConnectPage()),
          ),

          // Shared view
          GoRoute(
            path: '/help_guide',
            pageBuilder:
                (context, state) => _instantPage(const HelpGuidePage()),
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
