import 'package:flutter/material.dart';
import 'package:care_link/widgets/tiles/line_dot_title.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          const LineDotTitle(title: 'Welkom!'),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Blijf verbonden met uw naaste en ontvang hier alle meldingen in één overzicht.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Color(0xFF005159),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
