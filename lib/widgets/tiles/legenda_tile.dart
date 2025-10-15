import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LegendaTile extends StatefulWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const LegendaTile({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  @override
  State<LegendaTile> createState() => _LegendaTileState();
}

class _LegendaTileState extends State<LegendaTile> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tileWidth = (width * 0.33).clamp(110.0, 150.0);

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
          width: tileWidth,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                widget.isActive
                    ? widget.color.withOpacity(0.1)
                    : widget.color.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _isFocused ? widget.color : widget.color.withOpacity(0.8),
              width: _isFocused ? 2 : 1,
            ),
            boxShadow:
                widget.isActive
                    ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.45),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
