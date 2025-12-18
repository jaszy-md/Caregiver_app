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

    _resolvePatientAndStats();
  }

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
    });

    ref
        .read(statsContextProvider.notifier)
        .setContext(
          targetUid: patientUid,
          displayName: patient?['name'],
          weekPercentage: weekPercentage,
        );

    _weekTileController.forward(from: 0);
  }

  @override
  void dispose() {
    for (final ctrl in _tileControllers.values) {
      ctrl.dispose();
    }
    _tileControllers.clear();
    _weekTileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 8;
    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;

    if (caregiverUid == null) {
      return const Center(child: Text('Niet ingelogd'));
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

          NotificationTitleTile(
            label: 'Notificaties',
            onClearAll: () async {
              final userService = UserService();

              /// 1️⃣ UI eerst veilig leegmaken
              for (final ctrl in _tileControllers.values) {
                ctrl.dispose();
              }
              _tileControllers.clear();

              /// 2️⃣ Provider laten hertekenen
              ref.invalidate(receivedNotificationsProvider(caregiverUid));

              /// 3️⃣ Daarna pas Firestore opschonen
              await userService.deleteAllReceivedNotifications(caregiverUid);
            },
          ),

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
                error: (_, __) => const Center(child: Text('Fout bij laden')),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('Geen notificaties ontvangen'),
                    );
                  }
                  return _buildList(items, caregiverUid);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<ReceivedNotification> items, String caregiverUid) {
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
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                255,
                                133,
                                26,
                                17,
                              ).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) async {
                            final userService = UserService();
                            await userService.deleteReceivedNotification(
                              caregiverUid,
                              item.id,
                            );
                            _tileControllers.remove(item.id)?.dispose();
                          },
                          child: NotificationTile(
                            label: item.receivedLabel,
                            receivedAt: item.createdAt,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
