import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConcernedNotificationDialog extends StatelessWidget {
  final String phoneNumber;

  const ConcernedNotificationDialog({super.key, required this.phoneNumber});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 50),
      child: Transform.translate(
        offset: const Offset(0, 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(13, 18, 13, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFCAE7EA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color.fromARGB(255, 67, 6, 6),
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'We maken ons zorgen',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003F43),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.health_and_safety,
                    size: 20,
                    color: Color(0xFF003F43),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF003F43),
                  ),
                  children: [
                    TextSpan(
                      text: 'U heeft veel berichten verstuurd in korte tijd. ',
                    ),
                    TextSpan(text: 'Direct contact kan nu helpen. '),
                    TextSpan(text: 'Wilt u uw '),
                    TextSpan(
                      text: 'noodcontact',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: ' bellen?'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Annuleren',
                      color: const Color(0xFF0A5C60),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Bellen',
                      color: const Color(0xFF860207),
                      onTap: () {
                        Navigator.pop(context);
                        _call();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
