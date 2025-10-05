import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CaregiverSubHeader extends StatelessWidget {
  const CaregiverSubHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: const Color(0xFF0C3337),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItemWithImage(
            context,
            imagePath: 'assets/images/id-icon.png',
            label: 'Jouw ID',
            route: '/caregiver_id',
            imageLeft: true,
          ),
          Image.asset(
            'assets/images/logo-heart.png',
            height: 41,
            width: 44,
            color: Colors.white,
          ),
          _buildNavItemWithImage(
            context,
            imagePath: 'assets/images/question-cloud-icon.png',
            label: 'Hulpgids',
            route: '/help_guide',
            imageLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemWithImage(
    BuildContext context, {
    required String imagePath,
    required String label,
    required String route,
    required bool imageLeft,
  }) {
    final imageWidget = Image.asset(
      imagePath,
      height: 30,
      width: 30,
      color: Colors.white,
    );

    final textWidget = Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w500,
      ),
    );

    return GestureDetector(
      onTap: () => context.go(route),
      child: Row(
        children:
            imageLeft
                ? [imageWidget, const SizedBox(width: 4), textWidget]
                : [textWidget, const SizedBox(width: 4), imageWidget],
      ),
    );
  }
}
