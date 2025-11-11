import 'package:flutter/material.dart';
import 'package:care_link/gen/assets.gen.dart';

class NotificationTile extends StatelessWidget {
  final String label;
  final DateTime receivedAt;

  const NotificationTile({
    super.key,
    required this.label,
    required this.receivedAt,
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

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF96DFE6),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
            top: 2,
            bottom: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Tijd, veilig omhoog getild met Transform
              Transform.translate(
                offset: const Offset(0, -6), // schuift 6 pixels omhoog
                child: Text(
                  timeAgo,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
