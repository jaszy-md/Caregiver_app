import 'package:flutter/material.dart';

class NotificationTitleTile extends StatelessWidget {
  final String label;

  const NotificationTitleTile({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 170, minHeight: 50),
            padding: const EdgeInsets.only(left: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF008F9D),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border(
                top: BorderSide(color: Color(0xFF00282C), width: 2),
                right: BorderSide(color: Color(0xFF00282C), width: 2),
                bottom: BorderSide(color: Color(0xFF00282C), width: 2),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
