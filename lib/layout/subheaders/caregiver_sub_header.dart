import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/gen/assets.gen.dart';

class CaregiverSubHeader extends StatelessWidget {
  const CaregiverSubHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: const Color(0xFF0C3337),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItemWithImage(
            context,
            assetImage: Assets.images.idIcon,
            label: 'Jouw ID',
            route: '/caregiver_id',
            imageLeft: true,
          ),
          Assets.images.logoHeart.image(
            height: 41,
            width: 44,
            color: Colors.white,
          ),
          _buildNavItemWithImage(
            context,
            assetImage: Assets.images.questionCloudIcon,
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
    required AssetGenImage assetImage,
    required String label,
    required String route,
    required bool imageLeft,
  }) {
    final imageWidget = assetImage.image(
      height: 30,
      width: 30,
      color: Colors.white,
      fit: BoxFit.contain,
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
