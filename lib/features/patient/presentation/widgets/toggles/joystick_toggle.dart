import 'package:flutter/material.dart';

class JoystickToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const JoystickToggle({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<JoystickToggle> createState() => _JoystickToggleState();
}

class _JoystickToggleState extends State<JoystickToggle>
    with SingleTickerProviderStateMixin {
  late bool isActive;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    isActive = widget.initialValue;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: isActive ? 1.0 : 0.0,
    );
  }

  void _toggle() {
    setState(() => isActive = !isActive);
    isActive ? _controller.forward() : _controller.reverse();
    widget.onChanged(isActive);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF005159);
    final inactiveColor = const Color(0xFF94C2C2);

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final showBorder = t < 0.4;

          return Container(
            width: 60,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color.lerp(inactiveColor, activeColor, t)!,
                  Color.lerp(Colors.white, const Color(0xFF007F8C), t)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border:
                  showBorder
                      ? Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.2,
                      )
                      : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15 * t),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: Align(
              alignment:
                  Alignment.lerp(
                    Alignment.centerLeft,
                    Alignment.centerRight,
                    t,
                  )!,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
