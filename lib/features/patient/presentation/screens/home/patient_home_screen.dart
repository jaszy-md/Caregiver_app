import 'package:care_link/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:care_link/features/patient/data/patient_notifications.dart';
import 'package:care_link/features/patient/presentation/widgets/sections/patient_notifications_section.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with AutomaticKeepAliveClientMixin {
  String _selectedText = '';
  bool joystickActive = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (patientNotifications.isNotEmpty) {
      _selectedText = patientNotifications.first['label']!;
    }
  }

  void _onTileSelected(String text) {
    setState(() => _selectedText = text);
  }

  void updateJoystick(bool value) {
    setState(() => joystickActive = value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Assets.images.noteCloud.image(
                  width: 280,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.high,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
