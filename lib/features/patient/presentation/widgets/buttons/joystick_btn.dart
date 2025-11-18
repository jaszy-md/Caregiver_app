import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:care_link/gen/assets.gen.dart';

class JoystickButton extends StatefulWidget {
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onOk;

  const JoystickButton({
    super.key,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
    required this.onOk,
  });

  @override
  State<JoystickButton> createState() => _JoystickButtonState();
}

class _JoystickButtonState extends State<JoystickButton> {
  String _selected = 'left';
  String _pressed = '';

  void _activate(String dir) {
    setState(() {
      _pressed = dir;
      _selected = dir;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && _pressed == dir) setState(() => _pressed = '');
    });

    switch (dir) {
      case 'up':
        widget.onUp();
        break;
      case 'down':
        widget.onDown();
        break;
      case 'left':
        widget.onLeft();
        break;
      case 'right':
        widget.onRight();
        break;
      case 'ok':
        widget.onOk();
        break;
    }
  }

  void _move(String dir) {
    setState(() {
      switch (_selected) {
        case 'left':
          if (dir == 'right') _selected = 'ok';
          if (dir == 'up') _selected = 'up';
          if (dir == 'down') _selected = 'down';
          break;
        case 'right':
          if (dir == 'left') _selected = 'ok';
          if (dir == 'up') _selected = 'up';
          if (dir == 'down') _selected = 'down';
          break;
        case 'up':
          if (dir == 'down') _selected = 'ok';
          if (dir == 'left') _selected = 'left';
          if (dir == 'right') _selected = 'right';
          break;
        case 'down':
          if (dir == 'up') _selected = 'ok';
          if (dir == 'left') _selected = 'left';
          if (dir == 'right') _selected = 'right';
          break;
        case 'ok':
          _selected = dir;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const glow = Color(0xFF00E6E6);
    const focus = Color(0xFF00CFFF);

    const double controllerSize = 90;
    const double arrowSize = 23;
    const double okSize = 25;
    const double spacing = 4;

    return FocusTraversalGroup(
      child: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        autofocus: true,
        onKeyEvent: (event) {
          if (event is! KeyDownEvent) return;
          final key = event.logicalKey;
          if (key == LogicalKeyboardKey.arrowUp) _move('up');
          if (key == LogicalKeyboardKey.arrowDown) _move('down');
          if (key == LogicalKeyboardKey.arrowLeft) _move('left');
          if (key == LogicalKeyboardKey.arrowRight) _move('right');
          if (key == LogicalKeyboardKey.enter ||
              key == LogicalKeyboardKey.space) {
            _activate(_selected);
          }
        },
        child: Container(
          width: controllerSize,
          height: controllerSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment(0, 0),
              radius: 0.95,
              colors: [Color(0xFF002020), Color(0xFF000A0A)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 65, 201, 176),
                blurRadius: 20,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: spacing,
                child: _focusableArrow(
                  'up',
                  0,
                  isSelected: _selected == 'up',
                  isPressed: _pressed == 'up',
                  size: arrowSize,
                ),
              ),
              Positioned(
                bottom: spacing,
                child: _focusableArrow(
                  'down',
                  3.14,
                  isSelected: _selected == 'down',
                  isPressed: _pressed == 'down',
                  size: arrowSize,
                ),
              ),
              Positioned(
                left: spacing,
                child: _focusableArrow(
                  'left',
                  -1.57,
                  isSelected: _selected == 'left',
                  isPressed: _pressed == 'left',
                  size: arrowSize,
                ),
              ),
              Positioned(
                right: spacing,
                child: _focusableArrow(
                  'right',
                  1.57,
                  isSelected: _selected == 'right',
                  isPressed: _pressed == 'right',
                  size: arrowSize,
                ),
              ),
              _focusableOk(
                okSize,
                const Color.fromARGB(255, 0, 230, 184),
                const Color.fromARGB(255, 0, 255, 247),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusableArrow(
    String dir,
    double rot, {
    required bool isSelected,
    required bool isPressed,
    required double size,
  }) {
    const glow = Color(0xFF00E6E6);
    const focus = Color.fromARGB(255, 0, 255, 221);
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) setState(() => _selected = dir);
      },
      child: GestureDetector(
        onTap: () {
          setState(() => _selected = dir);
          _activate(dir);
        },
        child: Transform.rotate(
          angle: rot,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? focus : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isPressed ? glow.withOpacity(0.9) : glow.withOpacity(0.4),
                  blurRadius: isPressed ? 10 : 6,
                  spreadRadius: isPressed ? 2 : 1,
                ),
              ],
            ),
            child: Assets.images.arrowJoystick.image(fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Widget _focusableOk(double size, Color glow, Color focus) {
    final bool sel = _selected == 'ok';
    final bool act = _pressed == 'ok';
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) setState(() => _selected = 'ok');
      },
      child: GestureDetector(
        onTap: () {
          setState(() => _selected = 'ok');
          _activate('ok');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment(0, -0.3),
              radius: 0.9,
              colors: [Color(0xFF004C4C), Color(0xFF001A1A)],
            ),
            border: Border.all(
              color: sel ? focus : Colors.white.withOpacity(0.9),
              width: sel ? 2.0 : 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: act ? glow.withOpacity(0.9) : glow.withOpacity(0.4),
                blurRadius: act ? 10 : 6,
                spreadRadius: act ? 2 : 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "OK",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.white,
                shadows: [Shadow(color: glow, blurRadius: 6)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
