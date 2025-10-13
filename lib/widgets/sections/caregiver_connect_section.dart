import 'package:flutter/material.dart';

class CaregiverConnectSection extends StatelessWidget {
  const CaregiverConnectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        width: size.width * 0.8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/connect-mantelzorger.png',
                width: size.width * 0.8,
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * 0.020),
                  Container(
                    height: 57,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(0.0, -0.6),
                        radius: 2.0,
                        colors: [Color(0xFF63A5A3), Color(0xFF4E908C)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: const TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Voer mantelzorger-ID in',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: 120,
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(0.1, -0.4),
                        radius: 2.0,
                        colors: [Color(0xFF55BCC6), Color(0xFF3A8188)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Opslaan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 0.3),
                            blurRadius: 0.2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: size.height * 0.18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00282C),
                      border: Border.all(color: Colors.white, width: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/images/caregiver-connect.png',
                          width: size.width * 0.4,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.045),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
