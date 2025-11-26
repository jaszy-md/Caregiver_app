import 'dart:math' as math;
import 'package:care_link/core/utils/dialog_utils.dart';
import 'package:care_link/features/auth/data/services/auth_flow_service.dart';
import 'package:flutter/material.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/features/auth/data/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.loginBackground2.image(fit: BoxFit.cover),
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
                    width: 247,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final user = await AuthService().signInWithGoogle();

                        if (user != null) {
                          print('✅ Ingelogd als ${user.displayName}');

                          final nextRoute =
                              await AuthFlowService().resolveNextRoute();

                          if (context.mounted) context.go(nextRoute);
                        } else {
                          await showCareLinkErrorDialog(
                            context,
                            title: 'Netwerkprobleem',
                            message:
                                'Er ging iets mis tijdens het inloggen. Controleer of je verbonden bent met wifi of mobiele data en probeer het opnieuw.',
                          );
                        }
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
      ),
    );
  }
}
