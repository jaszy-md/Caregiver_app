import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/login-shape.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo-green-slogan.png',
                  height: 80,
                  width: 248,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.go('/home');
                  },
                  child: Container(
                    width: 237,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/google.png',
                        fit: BoxFit.contain,
                        height: 65,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Transform.rotate(
                  angle: -2.72 * math.pi / 180,
                  child: const Text(
                    'Log hier gemakkelijk in met jouw Google account!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'JustMeAgainDownHere',
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 100,
            left: 20,
            child: Image.asset(
              'assets/images/arrow-login.png',
              height: 56,
              width: 56,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
