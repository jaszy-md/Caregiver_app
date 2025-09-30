import 'package:care_link/layout/footers/main_footer.dart';
import 'package:care_link/layout/headers/main_header.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: const MainHeader(),
      body: child,
      bottomNavigationBar: const MainFooter(),
    );
  }
}
