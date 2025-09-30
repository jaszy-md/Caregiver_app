import 'package:care_link/views/login/login_page.dart';
import 'package:go_router/go_router.dart';
import '../layout/main_layout/main_layout.dart';
import '../views/home/home_page.dart';
import '../views/healthcheck/healthcheck_page.dart';
import '../views/profile/profile_page.dart';
import '../views/splash/splash_page.dart';

class AppNavigation {
  AppNavigation._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder:
            (context, state) => const NoTransitionPage(child: SplashPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder:
            (context, state) => const NoTransitionPage(child: LoginPage()),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/healthcheck',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: HealthCheckPage()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ProlfilePage()),
          ),
        ],
      ),
    ],
  );
}
