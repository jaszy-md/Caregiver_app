import 'package:care_link/features/patient/presentation/widgets/animations/animated_arrow.dart';
import 'package:flutter/material.dart';

class ConnectStepTile extends StatelessWidget {
  final String number;
  final String text;
  final IconData? icon;
  final bool showArrow;
  final VoidCallback? onTap;

  const ConnectStepTile({
    super.key,
    required this.number,
    required this.text,
    this.icon,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tileHeight = size.height * 0.055;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: tileHeight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            constraints: const BoxConstraints(minWidth: 200),
            decoration: const BoxDecoration(
              color: Color(0xFF04454B),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$number.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 23),
                      if (showArrow) ...[
                        const SizedBox(width: 4),
                        const AnimatedArrow(
                          width: 30,
                          height: 40,
                          offsetDistance: 0.15,
                          duration: Duration(milliseconds: 900),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
