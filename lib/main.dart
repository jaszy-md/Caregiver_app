import 'package:flutter/material.dart';
import 'navigation/app_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProjectBaseApp());
}

class ProjectBaseApp extends StatelessWidget {
  const ProjectBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
