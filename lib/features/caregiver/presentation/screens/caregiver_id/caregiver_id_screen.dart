import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:care_link/gen/assets.gen.dart';

class CaregiverIdScreen extends StatelessWidget {
  const CaregiverIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.75;
    final double imageHeight = imageWidth * 1.3;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: imageWidth,
        height: imageHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.caregiverId.image(
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned(
              right: imageWidth * 0.27,
              bottom: imageHeight * 0.13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: imageWidth * 0.09),
                    child: const Text(
                      'Jasmin',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SJ5FK2',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            const ClipboardData(text: 'SJ5FK2'),
                          );
                        },
                        child: const Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
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
