import 'package:care_link/core/providers/user_providers.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/shared/presentation/widgets/buttons/main_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrehomeScreen extends ConsumerWidget {
  const PrehomeScreen({super.key});

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

            // PATIËNT
            MainBtn(
              text: 'Zorgbehoevende',
              color: MainBtnColor.darkGreen,
              onTap: () async {
                await ref.read(setUserRoleProvider('patient').future);
                if (context.mounted) {
                  context.go('/patienthome');
                }
              },
            ),

            const SizedBox(height: 20),

            // MANTELZORGER
            MainBtn(
              text: 'Mantelzorger',
              color: MainBtnColor.lightGreen,
              onTap: () async {
                await ref.read(setUserRoleProvider('caregiver').future);
                if (context.mounted) {
                  context.go('/caregiverhome');
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
