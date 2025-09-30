import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainFooter extends StatelessWidget {
  const MainFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getSelectedIndex(uri);

    return Container(
      height: 60,
      color: const Color(0xFFE0E0E0),
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
            icon: Icons.star,
            route: '/page2',
          ),
          _buildNavItem(
            context: context,
            index: 2,
            selectedIndex: selectedIndex,
            icon: Icons.settings,
            route: '/page3',
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
    return GestureDetector(
      onTap: () => context.go(route),
      child: Icon(
        icon,
        size: 30,
        color:
            index == selectedIndex
                ? Colors.grey[800] // donkergrijs voor geselecteerde pagina
                : Colors.grey[600], // normaal grijs
      ),
    );
  }

  int _getSelectedIndex(String uri) {
    if (uri.startsWith('/page2')) return 1;
    if (uri.startsWith('/page3')) return 2;
    return 0;
  }
}
