import 'package:flutter/material.dart';

class ClearNotificationsDialog extends StatelessWidget {
  final Future<void> Function() onConfirm;

  const ClearNotificationsDialog({super.key, required this.onConfirm});

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Notificaties verwijderen',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003F43),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.delete_forever,
                    size: 20,
                    color: Color(0xFF003F43),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'Weet u zeker dat u alle notificaties wilt verwijderen?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xFF003F43),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Annuleren',
                      color: Color(0xFF0A5C60),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Verwijderen',
                      color: Color(0xFF860207),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();

                        Future.microtask(() async {
                          await onConfirm();
                        });
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
