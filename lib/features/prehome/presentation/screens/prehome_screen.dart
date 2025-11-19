import 'package:care_link/core/riverpod_providers/user_providers.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/shared/presentation/widgets/buttons/main_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrehomeScreen extends ConsumerWidget {
  const PrehomeScreen({super.key});

  void _log(String msg) {
    debugPrint("🟩 PREHOME: $msg");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Assets.images.together.image(fit: BoxFit.contain),
        ),

        Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Selecteer uw rol',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Color(0xFF005159),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Assets.images.dotLine.image(
                width: 330,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 60),

            // PATIËNT KNOP
            MainBtn(
              text: 'Zorgbehoevende',
              color: MainBtnColor.darkGreen,
              onTap: () async {
                _log("Klik op PATIENT knop");

                try {
                  _log("Start role update -> 'patient'");
                  await ref.read(setUserRoleProvider('patient').future);
                  _log("Rol opgeslagen: patient");

                  if (context.mounted) {
                    _log("Navigeren naar /patienthome");
                    context.go('/patienthome');
                  }
                } catch (e) {
                  _log("❌ ERROR bij opslaan patient rol: $e");
                }
              },
            ),

            const SizedBox(height: 20),

            // MANTELZORGER KNOP
            MainBtn(
              text: 'Mantelzorger',
              color: MainBtnColor.lightGreen,
              onTap: () async {
                _log("Klik op CAREGIVER knop");

                try {
                  _log("Start role update -> 'caregiver'");
                  await ref.read(setUserRoleProvider('caregiver').future);
                  _log("Rol opgeslagen: caregiver");

                  if (context.mounted) {
                    _log("Navigeren naar /caregiverhome");
                    context.go('/caregiverhome');
                  }
                } catch (e) {
                  _log("❌ ERROR bij opslaan caregiver rol: $e");
                }
              },
            ),

            const Spacer(),
          ],
        ),
      ],
    );
  }
}
