import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/gen/assets.gen.dart';

class WeekStateTile extends StatelessWidget {
  final String percentage;

  const WeekStateTile({super.key, this.percentage = '25%'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/stats');
      },
      child: SizedBox(
        width: 140,
        height: 130,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Assets.images.statusWidget.image(
              fit: BoxFit.fill,
              width: 140,
              height: 130,
            ),
            Transform.translate(
              offset: const Offset(-10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    percentage,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF005159),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -6),
                    child: const Text(
                      'Week status',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF005159),
                      ),
                    ),
                  ),
                  Assets.images.graphUp.image(
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
