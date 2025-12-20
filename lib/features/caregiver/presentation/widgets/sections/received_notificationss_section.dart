import 'package:care_link/core/firestore/models/received_notification.dart';
import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/core/riverpod_providers/received_notifications_providers.dart';
import 'package:care_link/features/caregiver/presentation/widgets/notifications/received_notification_tile.dart';
import 'package:care_link/features/caregiver/presentation/widgets/notifications/notification_title_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceivedNotificationsSection extends ConsumerStatefulWidget {
  const ReceivedNotificationsSection({super.key});

  @override
  ConsumerState<ReceivedNotificationsSection> createState() =>
      _ReceivedNotificationsSectionState();
}

class _ReceivedNotificationsSectionState
    extends ConsumerState<ReceivedNotificationsSection>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _tileControllers = {};
  final ScrollController _scrollController = ScrollController();

  bool _clearingAll = false;
  List<ReceivedNotification> _currentItems = [];

  @override
  void dispose() {
    for (final ctrl in _tileControllers.values) {
      ctrl.dispose();
    }
    _tileControllers.clear();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _clearAll() async {
    if (_clearingAll || _currentItems.isEmpty) return;

    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) return;

    setState(() => _clearingAll = true);
    final userService = UserService();

    for (final item in List<ReceivedNotification>.from(_currentItems)) {
      final ctrl = _tileControllers[item.id];
      if (ctrl == null) continue;

      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      }

      await ctrl.reverse();
      ctrl.dispose();
      _tileControllers.remove(item.id);

      await userService.deleteReceivedNotification(caregiverUid, item.id);
      await Future.delayed(const Duration(milliseconds: 60));
    }

    if (mounted) {
      setState(() {
        _clearingAll = false;
        _currentItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) {
      return const Center(child: Text('Niet ingelogd'));
    }

    final bottomPadding = MediaQuery.of(context).padding.bottom + 8;
    final asyncNotifications = ref.watch(
      receivedNotificationsProvider(caregiverUid),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationTitleTile(label: 'Notificaties', onClearAll: _clearAll),

        const SizedBox(height: 3),

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: bottomPadding,
            ),
            child: asyncNotifications.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const Center(child: Text('Fout bij laden')),
              data: (items) {
                _currentItems = items;

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
    );
  }

  Widget _buildList(List<ReceivedNotification> items, String caregiverUid) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children:
            items.map((item) {
              _tileControllers.putIfAbsent(
                item.id,
                () => AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 450),
                )..forward(),
              );

              final ctrl = _tileControllers[item.id]!;

              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.25),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
                ),
                child: FadeTransition(
                  opacity: ctrl,
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
                          child: ReceivedNotificationTile(
                            label: item.receivedLabel,
                            receivedAt: item.createdAt,
                            patientName: item.patientName,
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
