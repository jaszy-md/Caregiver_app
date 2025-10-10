import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: const Color.fromARGB(255, 0, 25, 28),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00282C),
                  Color(0xFF90A8AA),
                  Color.fromARGB(255, 255, 255, 255),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
            child: SizedBox(
              height: preferredSize.height,
              child: Center(
                child: Image.asset(
                  'assets/images/logo-wit.png',
                  height: 80,
                  width: 197,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
