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
              child: Assets.images.loginBackground3.image(fit: BoxFit.cover),
            ),

            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.images.loginGreen.image(
                    height: 80,
                    width: 247,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
