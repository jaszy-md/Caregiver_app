import 'package:flutter/material.dart';

class LineDotTitle extends StatelessWidget {
  final String title;
  const LineDotTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const lineColor = Color(0xFF00828E);
    const textColor = Color(0xFF005159);

    final textStyle = const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: textColor,
    );

    // calc line space
    final textPainter = TextPainter(
      text: TextSpan(text: title, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    // extra line space
    const double extraSpace = 40;
    const double dotSize = 17;
    final double lineWidth = textPainter.width + extraSpace;
    final double totalWidth = lineWidth + dotSize;

    return SizedBox(
      width: totalWidth,
      height: 50,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                Container(width: lineWidth, height: 3, color: lineColor),
                Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: const BoxDecoration(
                    color: lineColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 12,
            left: 20,
            right: 0,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(title, style: textStyle),
            ),
          ),
        ],
      ),
    );
  }
}
