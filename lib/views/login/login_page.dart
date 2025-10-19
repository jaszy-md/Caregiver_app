import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.loginBackground.image(fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Assets.images.loginShape.image(fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.images.logoGreenSlogan.image(
                  height: 80,
                  width: 248,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      context.go('/prehome');
                    },
                    child: Container(
                      width: 237,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Assets.images.google.image(
                          fit: BoxFit.contain,
                          height: 65,
                        ),
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
            child: Assets.images.arrowLogin.image(
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
