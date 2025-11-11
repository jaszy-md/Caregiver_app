import 'package:flutter/material.dart';

class MainBtn extends StatelessWidget {
  final String text;
  final MainBtnColor color;
  final VoidCallback? onTap;

  const MainBtn({
    super.key,
    required this.text,
    this.color = MainBtnColor.darkGreen,
    this.onTap,
  });

  static const Color darkGreen = Color(0xFF005159);
  static const Color lightGreen = Color(0xFF006772);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color == MainBtnColor.darkGreen ? darkGreen : lightGreen,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

enum MainBtnColor { darkGreen, lightGreen }
