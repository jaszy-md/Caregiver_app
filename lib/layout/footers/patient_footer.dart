import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class PatientFooter extends StatefulWidget {
  const PatientFooter({super.key});

  static final List<String> _routes = [
    '/patienthome',
    '/healthcheck',
    '/patientprofile',
  ];

  @override
  State<PatientFooter> createState() => _PatientFooterState();
}

class _PatientFooterState extends State<PatientFooter> {
  int focusedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _getSelectedIndex(location);

    const footerColor = Color.fromARGB(255, 0, 25, 28);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 90,
            decoration: const BoxDecoration(
              color: footerColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  index: 0,
                  selectedIndex: selectedIndex,
                  icon: Icons.home,
                  route: '/patienthome',
                ),
                _buildNavItem(
                  context: context,
                  index: 1,
                  selectedIndex: selectedIndex,
                  icon: Icons.menu_book,
                  route: '/healthcheck',
                ),
                _buildNavItem(
                  context: context,
                  index: 2,
                  selectedIndex: selectedIndex,
                  icon: Icons.person,
                  route: '/patientprofile',
                ),
              ],
            ),
          ),

          if (bottomPadding > 0)
            Container(height: bottomPadding, color: footerColor),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int selectedIndex,
    required IconData icon,
    required String route,
  }) {
    final isSelected = index == selectedIndex;
    final isFocused = index == focusedIndex;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          context.go(route);
        }
      },
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 43, color: Colors.white),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 42,
                color: Colors.white,
              ),
            if (isFocused && !isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 42,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  int _getSelectedIndex(String location) {
    final index = PatientFooter._routes.indexWhere(
      (route) => location.startsWith(route),
    );
    return index == -1 ? 0 : index;
  }
}
