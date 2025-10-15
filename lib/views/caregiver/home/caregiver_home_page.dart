import 'package:care_link/widgets/notifications/notification_tile.dart';
import 'package:care_link/widgets/notifications/notification_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:care_link/widgets/tiles/line_dot_title.dart';

class CaregiverHomePage extends StatefulWidget {
  const CaregiverHomePage({super.key});

  @override
  State<CaregiverHomePage> createState() => _CaregiverHomePageState();
}

class _CaregiverHomePageState extends State<CaregiverHomePage> {
  final List<String> _notifications = [
    '“Ik heb honger”',
    '“Ik moet naar het toilet”',
    '“I miss you”',
    '“I love you!”',
    '“Ik wil naar buiten”',
  ];

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 8;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          const LineDotTitle(title: 'Welkom!'),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Blijf verbonden met uw naaste en ontvang hier alle meldingen in één overzicht.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Color(0xFF005159),
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 11),

          const NotificationTitleTile(label: 'Notificaties'),

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
                        itemCount: _notifications.length,
                        padding: const EdgeInsets.only(
                          top: 3,
                          bottom: 20,
                          left: 5,
                          right: 5,
                        ),
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return Stack(
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
                                      _notifications.removeAt(index);
                                    });
                                  },
                                  child: NotificationTile(label: notification),
                                ),
                              ),
                            ],
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
