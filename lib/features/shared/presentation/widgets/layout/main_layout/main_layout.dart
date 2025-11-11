import 'package:care_link/features/shared/presentation/widgets/layout/headers/main_header.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final Widget? footer;
  final Widget? subHeader;
  final bool showHeader;

  const MainLayout({
    super.key,
    required this.child,
    this.footer,
    this.subHeader,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final header = showHeader ? const MainHeader() : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [if (subHeader != null) subHeader!, Expanded(child: child)],
      ),
      bottomNavigationBar: footer,
    );
  }
}
