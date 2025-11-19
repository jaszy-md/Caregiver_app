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
  late final AnimationController _tileController;

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

    _tileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _weekTileController.forward(from: 0);
      if (mounted) _tileController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _weekTileController.dispose();
    _tileController.dispose();
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
              if (_weekTileAnimation != null)
                SlideTransition(
                  position: _weekTileAnimation!,
                  child: const WeekStateTile(),
                )
              else
                const WeekStateTile(),
            ],
          ),

          const SizedBox(height: 10),

          // Titeltegel – nu zonder fake onTap
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

                  return _buildNotificationsList(
                    context: context,
                    items: items,
                    caregiverUid: caregiverUid,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList({
    required BuildContext context,
    required List<ReceivedNotification> items,
    required String caregiverUid,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight + 30),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              clipBehavior: Clip.none,
              itemCount: items.length,
              padding: const EdgeInsets.only(
                top: 3,
                bottom: 20,
                left: 5,
                right: 5,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                final tileAnimation = Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _tileController,
                    curve: Interval(
                      0.1 * index,
                      0.6 + 0.1 * index,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                );

                return SlideTransition(
                  position: tileAnimation,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 9),
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
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Dismissible(
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
