import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaregiverIdPage extends StatelessWidget {
  const CaregiverIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.75;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: imageWidth,
        height: imageWidth * 1.3,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/caregiver-id.png'),
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 90, bottom: 50),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
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
                        Clipboard.setData(const ClipboardData(text: 'SJ5FK2'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gekopieerd')),
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
        ),
      ),
    );
  }
}
