import 'package:flutter/material.dart';

class EmergencyContactDialog extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String?> onSave;

  const EmergencyContactDialog({
    super.key,
    this.initialValue,
    required this.onSave,
  });

  @override
  State<EmergencyContactDialog> createState() => _EmergencyContactDialogState();
}

class _EmergencyContactDialogState extends State<EmergencyContactDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 34),
      child: Transform.translate(
        offset: const Offset(0, 35),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 176, 220, 219),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF0A5C60), width: 2),
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
                        'Uw noodcontact',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003F43),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.phone_in_talk,
                        size: 20,
                        color: Color(0xFF003F43),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Vul uw noodcontact in.\n'
                    'Als u dit leeg laat, blijft het nummer op 112 staan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xFF003F43),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xFF003F43),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Bijvoorbeeld: 0612345678',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color.fromARGB(255, 126, 170, 174),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Annuleren',
                          backgroundColor: const Color(0xFF0A5C60),
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          label: 'Opslaan',
                          backgroundColor: const Color(0xFF005159),
                          onTap: () {
                            final value =
                                _controller.text.trim().isEmpty
                                    ? null
                                    : _controller.text.trim();
                            widget.onSave(value);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
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
