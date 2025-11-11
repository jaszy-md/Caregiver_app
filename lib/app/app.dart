import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Router
import 'package:care_link/app/router/app_router.dart';

// Network overlay (nog oude locatie!)
import 'package:care_link/notifiers/network_status_notifier.dart';
import 'package:care_link/app/network_badge_overlay.dart';

class CareLinkApp extends StatelessWidget {
  const CareLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NetworkStatusNotifier(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'CareLink',
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return NetworkBadgeOverlay(child: child!);
        },
      ),
    );
  }
}
