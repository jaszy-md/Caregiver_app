import 'package:flutter/material.dart';

class NotificationBlock extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isLocalAsset;
  final bool isActive;
  final VoidCallback onSelect;
  final Color activeColor;

  final double? customWidth;
  final double? customHeight;
  final double? customIconSize;

  const NotificationBlock({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isLocalAsset,
    required this.isActive,
    required this.onSelect,
    this.activeColor = const Color.fromARGB(255, 5, 148, 145),
    this.customWidth,
    this.customHeight,
    this.customIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final double width = customWidth ?? 92;
    final double height = customHeight ?? 76;
    final double iconSize =
        customIconSize ?? (width < height ? width * 0.88 : height * 0.88);

    final Widget img =
        isLocalAsset
            ? Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            )
            : Image.network(
              imagePath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelect,
      child: AnimatedContainer(
        duration: Duration.zero,
        curve: Curves.easeOut,
        width: width,
        height: height,

        margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(8),

          border: Border.all(
            color: isActive ? activeColor : Colors.black,
            width: isActive ? 3.2 : 1.4,
          ),

          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.45),
                      blurRadius: 9,
                      spreadRadius: 1.2,
                    ),
                  ]
                  : [],
        ),
        child: Center(child: img),
      ),
    );
  }
}
