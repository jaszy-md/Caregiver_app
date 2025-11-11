import 'package:care_link/app/carelink.dart';
import 'package:flutter/material.dart';
import 'package:care_link/app/network_badge_overlay.dart';

class NetworkBadgeWrapper extends StatelessWidget {
  const NetworkBadgeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkBadgeOverlay(child: const CareLink());
  }
}
