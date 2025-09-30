import 'package:go_router/go_router.dart';
import '../layout/main_layout/main_layout.dart';
import '../views/home/home_page.dart';
import '../views/page2/page2_page.dart';
import '../views/page3/page3_page.dart';
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
            path: '/page2',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: Page2Page()),
          ),
          GoRoute(
            path: '/page3',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: Page3Page()),
          ),
        ],
      ),
    ],
  );
}
