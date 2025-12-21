import 'package:flutter/material.dart';
import 'package:care_link/gen/assets.gen.dart';

class ReceivedNotificationTile extends StatelessWidget {
  final String label;
  final DateTime receivedAt;
  final String? patientName;

  const ReceivedNotificationTile({
    super.key,
    required this.label,
    required this.receivedAt,
    this.patientName,
  });

  String _formatAgo() {
    final now = DateTime.now();
    final diff = now.difference(receivedAt);

    if (diff.inMinutes < 1) return "zojuist";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min geleden";
    if (diff.inHours < 24) return "${diff.inHours} uur geleden";
    return "${diff.inDays} dagen geleden";
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = _formatAgo();
    final hasName = patientName != null && patientName!.trim().isNotEmpty;

    final double screenWidth = MediaQuery.of(context).size.width;

    final double nameFontSize = screenWidth > 380 ? 16 : 18;
    final double labelFontSize = screenWidth > 380 ? 17 : 16;
    final double timeFontSize = screenWidth > 380 ? 10 : 10;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF96DFE6),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.only(
            left: 22,
            right: 20,
            top: 12,
            bottom: 10,
          ),
          alignment: Alignment.centerLeft,
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 7, 54, 55),
              ),
              children: [
                if (hasName)
                  TextSpan(
                    text: '${patientName!.trim()}: ',
                    style: TextStyle(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 84, 179, 188),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Text(
              timeAgo,
              style: TextStyle(
                color: Colors.white,
                fontSize: timeFontSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: -20,
          child: Assets.images.notification.image(
            width: 53,
            height: 53,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
