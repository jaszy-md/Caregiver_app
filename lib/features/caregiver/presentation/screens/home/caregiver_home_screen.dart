import 'package:care_link/core/firestore/models/received_notification.dart';
import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/core/riverpod_providers/received_notifications_providers.dart';
import 'package:care_link/core/riverpod_providers/stats_context_provider.dart';
import 'package:care_link/features/caregiver/presentation/widgets/notifications/notification_tile.dart';
import 'package:care_link/features/caregiver/presentation/widgets/notifications/notification_title_tile.dart';
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

  final Map<String, AnimationController> _tileControllers = {};

  String? _patientUid;
  String? _patientName;
  int? _weekPercentage;

  @override
  void initState() {
    super.initState();

    _weekTileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _weekTileAnimation = Tween<Offset>(
      begin: const Offset(0.6, 0), // rustig
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _weekTileController, curve: Curves.easeOutCubic),
    );

    _resolvePatientAndStats();
  }

  /// 🔑 ENIGE BRON VAN WAARHEID
  Future<void> _resolvePatientAndStats() async {
    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) return;

    final userService = UserService();

    final patientUid = await userService.findPatientForCaregiver(caregiverUid);
    if (!mounted || patientUid == null) return;

    final patient = await userService.getUser(patientUid);

    final weekPercentage = await userService.calculateWeeklyHealthPercentage(
      patientUid,
    );

    if (!mounted) return;

    setState(() {
      _patientUid = patientUid;
      _patientName = patient?['name'];
      _weekPercentage = weekPercentage;
    });

    // 🔥 context vooraf zetten voor ALLE navigatie
    ref
        .read(statsContextProvider.notifier)
        .setContext(
          targetUid: patientUid,
          displayName: patient?['name'],
          weekPercentage: weekPercentage,
        );

    // 🎯 animatie pas starten als alles stabiel is
    _weekTileController.forward(from: 0);
  }

  @override
  void dispose() {
    for (final ctrl in _tileControllers.values) {
      ctrl.dispose();
    }
    _weekTileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 8;

    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) {
      return const Center(
        child: Text(
          'Niet ingelogd',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF005159),
          ),
        ),
      );
    }

    final asyncNotifications = ref.watch(
      receivedNotificationsProvider(caregiverUid),
    );

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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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

              // 🔹 Week tile
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
          const NotificationTitleTile(label: 'Notificaties'),
          const SizedBox(height: 3),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: bottomPadding,
              ),
              child: asyncNotifications.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (_, __) => const Center(
                      child: Text(
                        'Er ging iets mis bij het ophalen van notificaties',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF005159),
                        ),
                      ),
                    ),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'Geen notificaties ontvangen',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF005159),
                        ),
                      ),
                    );
                  }

                  return _buildList(items);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<ReceivedNotification> items) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children:
            items.map((item) {
              _tileControllers.putIfAbsent(
                item.id,
                () => AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 650),
                )..forward(),
              );

              final ctrl = _tileControllers[item.id]!;

              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.4),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 7,
                    ),
                    child: NotificationTile(
                      label: item.receivedLabel,
                      receivedAt: item.createdAt,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
