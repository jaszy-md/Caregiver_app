import 'package:care_link/core/firestore/models/received_notification.dart';
import 'package:care_link/core/riverpod_providers/received_notifications_providers.dart';
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
  Animation<Offset>? _weekTileAnimation;

  // Houd animatiestatus per tile bij
  final Map<String, AnimationController> _tileControllers = {};

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _weekTileController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    for (var ctrl in _tileControllers.values) {
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

          // week tile animatie
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
                position: _weekTileAnimation!,
                child: const WeekStateTile(),
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
                    (err, stack) => Center(
                      child: Text(
                        'Er ging iets mis bij het ophalen van notificaties',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF005159),
                        ),
                        textAlign: TextAlign.center,
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
            items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              // Controller per tile, alleen bij nieuwe tile maken
              if (!_tileControllers.containsKey(item.id)) {
                final ctrl = AnimationController(
                  vsync: this,
                  duration: Duration(milliseconds: 650),
                );
                _tileControllers[item.id] = ctrl;

                // animatie start direct bij nieuwe item
                ctrl.forward(from: 0);
              }

              final ctrl = _tileControllers[item.id]!;

              final animation = Tween<Offset>(
                begin: const Offset(0, -0.4),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
              );

              final fade = CurvedAnimation(parent: ctrl, curve: Curves.easeOut);

              return SlideTransition(
                position: animation,
                child: FadeTransition(
                  opacity: fade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 7,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Container(
                            height: 58, // exact zo groot als tile
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
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) async {
                            await ref
                                .read(receivedNotificationServiceProvider)
                                .deleteNotification(
                                  caregiverUid: caregiverUid,
                                  notificationId: item.id,
                                );
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
