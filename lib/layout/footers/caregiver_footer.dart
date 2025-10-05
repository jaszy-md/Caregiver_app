import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class CaregiverFooter extends StatefulWidget {
  const CaregiverFooter({super.key});

  static final List<String> _routes = [
    '/caregiverhome',
    '/stats',
    '/caregiverprofile',
  ];

  @override
  State<CaregiverFooter> createState() => _CaregiverFooterState();
}

class _CaregiverFooterState extends State<CaregiverFooter> {
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
                  route: '/caregiverhome',
                ),
                _buildNavItem(
                  context: context,
                  index: 1,
                  selectedIndex: selectedIndex,
                  imagePath: 'assets/images/stats-icon.png',
                  route: '/stats',
                ),
                _buildNavItem(
                  context: context,
                  index: 2,
                  selectedIndex: selectedIndex,
                  icon: Icons.person,
                  route: '/caregiverprofile',
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
    IconData? icon,
    String? imagePath,
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
            if (imagePath != null)
              Image.asset(
                imagePath,
                height: 40,
                width: 40,
                color:
                    Colors.white, // zodat het consistent is met de andere icons
              )
            else if (icon != null)
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
    final index = CaregiverFooter._routes.indexWhere(
      (route) => location.startsWith(route),
    );
    return index == -1 ? 0 : index;
  }
}
