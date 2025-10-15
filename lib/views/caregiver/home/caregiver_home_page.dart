import 'package:care_link/widgets/notifications/notification_tile.dart';
import 'package:care_link/widgets/notifications/notification_title_tile.dart';
import 'package:care_link/widgets/tiles/week-state-tile.dart';
import 'package:flutter/material.dart';
import 'package:care_link/widgets/tiles/line_dot_title.dart';

class CaregiverHomePage extends StatefulWidget {
  const CaregiverHomePage({super.key});

  @override
  State<CaregiverHomePage> createState() => _CaregiverHomePageState();
}

class _CaregiverHomePageState extends State<CaregiverHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _weekTileController;
  Animation<Offset>? _weekTileAnimation;

  late final AnimationController _tileController;

  final List<String> _allNotifications = [
    '“Ik heb honger”',
    '“Ik moet naar het toilet”',
    '“I miss you”',
    '“Ik wil naar buiten”',
  ];

  final List<String> _visibleNotifications = [];

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
    });
  }

  @override
  void dispose() {
    _weekTileController.dispose();
    _tileController.dispose();
    super.dispose();
  }

  void _addNotification() {
    if (_visibleNotifications.length < _allNotifications.length) {
      setState(() {
        _visibleNotifications.add(
          _allNotifications[_visibleNotifications.length],
        );
      });
      _tileController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 8;

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

          // Temporary test btn to add notificationss
          GestureDetector(
            onTap: _addNotification,
            child: const NotificationTitleTile(label: 'Notificaties'),
          ),

          const SizedBox(height: 3),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: bottomPadding,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_visibleNotifications.isEmpty) {
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

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight + 30,
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        itemCount: _visibleNotifications.length,
                        padding: const EdgeInsets.only(
                          top: 3,
                          bottom: 20,
                          left: 5,
                          right: 5,
                        ),
                        itemBuilder: (context, index) {
                          final notification = _visibleNotifications[index];

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
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 9,
                                    ),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Dismissible(
                                    key: Key(notification),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) {
                                      setState(() {
                                        _visibleNotifications.removeAt(index);
                                      });
                                    },
                                    child: NotificationTile(
                                      label: notification,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
