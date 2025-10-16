import 'package:flutter/material.dart';
import 'package:care_link/widgets/sections/patient_notifications_section.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  String _selectedText = '';

  void _onTileSelected(String text) {
    setState(() {
      _selectedText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/note-cloud.png',
                  width: 280,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 12),
                  child: Text(
                    _selectedText.isNotEmpty ? '“$_selectedText”' : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF005159),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          Expanded(
            child: Center(
              child: PatientNotificationsSection(
                onTileSelected: _onTileSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
