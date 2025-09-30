import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class MainFooter extends StatefulWidget {
  const MainFooter({super.key});

  static final List<String> _routes = ['/home', '/healthcheck', '/profile'];

  @override
  State<MainFooter> createState() => _MainFooterState();
}

class _MainFooterState extends State<MainFooter> {
  int focusedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _getSelectedIndex(location);

    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFF0C3337),
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
            route: '/home',
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
            route: '/profile',
          ),
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
    final index = MainFooter._routes.indexWhere(
      (route) => location.startsWith(route),
    );
    return index == -1 ? 0 : index;
  }
}
