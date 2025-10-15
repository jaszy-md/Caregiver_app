import 'package:care_link/widgets/buttons/notification_block.dart';
import 'package:flutter/material.dart';

class PatientNotificationsSection extends StatefulWidget {
  final ValueChanged<String> onTileSelected;

  const PatientNotificationsSection({super.key, required this.onTileSelected});

  @override
  State<PatientNotificationsSection> createState() =>
      _PatientNotificationsSectionState();
}

class _PatientNotificationsSectionState
    extends State<PatientNotificationsSection> {
  int _activeIndex = 0;

  final List<Map<String, String>> _blocks = [
    {'label': 'Ik heb honger', 'image': 'assets/images/eat.png'},
    {'label': 'Ik wil drinken', 'image': 'assets/images/drink.png'},
    {'label': 'Bel iemand', 'image': 'assets/images/call-caregiver.png'},
    {'label': 'Ik moet naar het toilet', 'image': 'assets/images/wc.png'},
    {'label': 'Laten we wandelen', 'image': 'assets/images/walk.png'},
    {'label': 'Ik wil rusten', 'image': 'assets/images/sleep.png'},
  ];

  void _handleTap(int index) {
    setState(() => _activeIndex = index);
    widget.onTileSelected(_blocks[index]['label']!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/ipad-container.png',
          fit: BoxFit.contain,
          width: 350,
          height: 450,
        ),
        Positioned.fill(
          top: 60,
          bottom: 60,
          left: 40,
          right: 40,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_blocks.length, (index) {
                final block = _blocks[index];
                return NotificationBlock(
                  label: block['label']!,
                  imagePath: block['image']!,
                  isActive: index == _activeIndex,
                  onTap: () => _handleTap(index),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
