import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationBlock extends StatefulWidget {
  final String label;
  final String imagePath;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const NotificationBlock({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isActive,
    required this.onTap,
    this.activeColor = const Color(0xFF00C7E5),
  });

  @override
  State<NotificationBlock> createState() => _NotificationBlockState();
}

class _NotificationBlockState extends State<NotificationBlock> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: widget.isActive,
      onFocusChange: (focus) => setState(() => _isFocused = focus),

      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },

      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) => widget.onTap(),
        ),
      },

      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 90,
          height: 90,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _isFocused || widget.isActive
                      ? widget.activeColor
                      : Colors.black,
              width: _isFocused || widget.isActive ? 3 : 1.5,
            ),
            boxShadow:
                _isFocused || widget.isActive
                    ? [
                      BoxShadow(
                        color: widget.activeColor.withOpacity(0.45),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
