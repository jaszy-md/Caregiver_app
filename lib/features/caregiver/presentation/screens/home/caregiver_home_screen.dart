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

class _CaregiverHomeScreenState extends ConsumerState<CaregiverHomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _weekTileController;
  late final Animation<Offset> _weekTileAnimation;

  String? _patientUid;

  @override
  void initState() {
    super.initState();

    _weekTileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _weekTileAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _weekTileController, curve: Curves.easeOutCubic),
    );

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

    _weekTileController.forward(from: 0);
  }

  @override
  void dispose() {
    _weekTileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) {
      return const Center(child: Text('Niet ingelogd'));
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          const LineDotTitle(title: 'Welkom!'),
          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
                  child: const Text(
                    'Blijf verbonden met uw naaste en ontvang hier alle meldingen in één overzicht.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: Color(0xFF005159),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _weekTileAnimation,
                child:
                    _patientUid == null
                        ? const SizedBox(width: 140, height: 130)
                        : const WeekStateTile(),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Expanded(child: ReceivedNotificationsSection()),
        ],
      ),
    );
  }
}
