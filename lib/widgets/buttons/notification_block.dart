import 'package:flutter/material.dart';

class NotificationBlock extends StatelessWidget {
  final String label;
  final String imagePath;
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
    required this.isActive,
    required this.onSelect,
    this.activeColor = const Color.fromARGB(255, 5, 148, 145),
    this.customWidth,
    this.customHeight,
    this.customIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final double width = customWidth ?? 70;
    final double height = customHeight ?? 55;
    final double iconSize =
        customIconSize ?? (width < height ? width * 0.75 : height * 0.75);

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: width,
        height: height,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor : Colors.black,
            width: isActive ? 3 : 1.5,
          ),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                  : [],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
