import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/shared/presentation/widgets/buttons/main_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrehomeScreen extends StatelessWidget {
  const PrehomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            MainBtn(
              text: 'Zorgbehoevende',
              color: MainBtnColor.darkGreen,
              onTap: () {
                context.go('/patienthome');
              },
            ),
            const SizedBox(height: 20),
            MainBtn(
              text: 'Mantelzorger',
              color: MainBtnColor.lightGreen,
              onTap: () {
                context.go('/caregiverhome');
              },
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
