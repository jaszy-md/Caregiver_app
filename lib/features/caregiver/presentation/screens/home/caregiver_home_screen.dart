import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/core/riverpod_providers/stats_context_provider.dart';
import 'package:care_link/core/riverpod_providers/active_patient_provider.dart';
import 'package:care_link/features/caregiver/presentation/widgets/sections/received_notificationss_section.dart';
import 'package:care_link/features/caregiver/presentation/widgets/tiles/week-state-tile.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/line_dot_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaregiverHomeScreen extends ConsumerStatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  ConsumerState<CaregiverHomeScreen> createState() =>
      _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends ConsumerState<CaregiverHomeScreen> {
  String? _patientUid;

  static const double notificationsMaxWidth = 412.0;

  @override
  void initState() {
    super.initState();
    _initPatientContext();
  }

  Future<void> _initPatientContext() async {
    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) return;

    final userService = UserService();

    final storedActiveUid = await userService.getActivePatientForCaregiver(
      caregiverUid,
    );

    final resolvedPatientUid =
        storedActiveUid ??
        await userService.findPatientForCaregiver(caregiverUid);

    if (!mounted || resolvedPatientUid == null) return;

    final patient = await userService.getUser(resolvedPatientUid);
    final weekPercentage = await userService.calculateWeeklyHealthPercentage(
      resolvedPatientUid,
    );

    if (!mounted) return;

    setState(() {
      _patientUid = resolvedPatientUid;
    });

    ref
        .read(activePatientProvider.notifier)
        .setActivePatient(resolvedPatientUid);

    ref
        .read(statsContextProvider.notifier)
        .setContext(
          targetUid: resolvedPatientUid,
          displayName: patient?['name'],
          weekPercentage: weekPercentage,
        );

    if (storedActiveUid == null) {
      await userService.setActivePatientForCaregiver(
        caregiverUid: caregiverUid,
        patientUid: resolvedPatientUid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) {
      return const Center(child: Text('Niet ingelogd'));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final double welcomeFontSize = screenWidth > 380 ? 20 : 19;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          // 🔒 Titel volledig losgekoppeld van route-animaties
          const RepaintBoundary(
            child: SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: LineDotTitle(title: 'Welkom!'),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    'Blijf verbonden met uw naaste en ontvang hier alle meldingen in één overzicht.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: welcomeFontSize,
                      color: const Color(0xFF005159),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const WeekStateTile(),
            ],
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: notificationsMaxWidth,
                ),
                child: const ReceivedNotificationsSection(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
