import 'package:flutter/material.dart';

class ContactConfirmationDialog extends StatelessWidget {
  const ContactConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFCAE7EA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF0A5C60), width: 4),
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
            children: const [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.support_agent, size: 22, color: Color(0xFF003F43)),
                  SizedBox(width: 8),
                  Text(
                    'Contact opgenomen',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003F43),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Dank u wel voor uw bericht.\n'
                'Wij nemen zo snel mogelijk contact met u op.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF003F43)),
              ),
              SizedBox(height: 12),
              Text(
                'Tik om te sluiten',
                style: TextStyle(fontSize: 12, color: Color(0xFF0A5C60)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
