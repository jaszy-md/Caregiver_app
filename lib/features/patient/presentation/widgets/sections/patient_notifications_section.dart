import 'package:care_link/core/firestore/services/notifications_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:care_link/core/firestore/models/notification_item.dart';
import 'package:care_link/features/patient/state/joystick_controller.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/patient/presentation/widgets/buttons/joystick_btn.dart';
import 'package:care_link/features/patient/presentation/widgets/notification_blocks/notification_block.dart';

class PatientNotificationsSection extends StatefulWidget {
  final List<NotificationItem> blocks;
  final ValueChanged<String> onTileSelected;

  const PatientNotificationsSection({
    super.key,
    required this.blocks,
    required this.onTileSelected,
  });

  @override
  State<PatientNotificationsSection> createState() =>
      _PatientNotificationsSectionState();
}

class _PatientNotificationsSectionState
    extends State<PatientNotificationsSection>
    with TickerProviderStateMixin {
  int _activeIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late final List<GlobalKey> _tileKeys;

  late final AnimationController _joystickController;
  late final Animation<Offset> _joystickAnimation;

  @override
  void initState() {
    super.initState();

    _tileKeys = List.generate(widget.blocks.length, (_) => GlobalKey());

    _joystickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _joystickAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _joystickController, curve: Curves.easeOutCubic),
    );

    JoystickController().activeNotifier.addListener(() {
      if (!mounted) return;
      if (JoystickController().active) {
        _joystickController.forward();
      } else {
        _joystickController.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (JoystickController().active) {
        _joystickController.forward(from: 0);
      }
    });
  }

  void _selectTile(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.blocks.length) return;

    setState(() => _activeIndex = newIndex);
    widget.onTileSelected(widget.blocks[newIndex].label);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _tileKeys[newIndex].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          alignment: 0.5,
        );
      }
    });
  }

  Future<void> _sendNotification(String label) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    final patientName = userDoc.data()?['name'] ?? 'Onbekend';

    await NotificationsService().sendNotificationToLinkedCaregivers(
      patientUid: user.uid,
      patientName: patientName,
      label: label,
    );

    debugPrint("📨 Verstuurd: $label");
  }

  void _moveSelection(String direction) {
    const columns = 3;
    int newIndex = _activeIndex;

    switch (direction) {
      case 'up':
        newIndex -= columns;
        break;
      case 'down':
        newIndex += columns;
        break;
      case 'left':
        newIndex--;
        break;
      case 'right':
        newIndex++;
        break;
    }

    if (newIndex < 0) newIndex = widget.blocks.length - 1;
    if (newIndex >= widget.blocks.length) newIndex = 0;

    _selectTile(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final blocks = widget.blocks;

    final width = MediaQuery.of(context).size.width;

    final double ipadWidth = (width * 0.8).clamp(300, 380);
    final double ipadHeight = ipadWidth * 1.255;
    final double horizontalPadding = ipadWidth * 0.135;
    final double verticalPadding = ipadHeight * 0.151;
    final double spacing = ipadWidth * 0.02;
    final double gridWidth = ipadWidth - (horizontalPadding * 2);
    final double tileWidth = (gridWidth - spacing * 2) / 3;
    final double tileHeight = tileWidth * 0.8;
    final double iconSize = tileWidth * 0.55;
    final double ipadImageScale =
        width < 380 ? 1.12 : (width < 430 ? 1.06 : 1.0);

    return RepaintBoundary(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: ipadImageScale,
              child: Assets.images.ipad.image(
                fit: BoxFit.contain,
                gaplessPlayback: true,
                filterQuality: FilterQuality.high,
              ),
            ),

            Positioned(
              top: verticalPadding - 30,
              left: 0,
              right: 0,
              child: const Text(
                "DUBBEL KLIK OM TE VERSTUREN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004F54),
                  letterSpacing: 0.6,
                ),
              ),
            ),

            Positioned(
              top: verticalPadding,
              bottom: verticalPadding,
              left: horizontalPadding,
              right: horizontalPadding,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: tileWidth / tileHeight,
                      ),
                      itemCount: blocks.length,
                      itemBuilder: (context, index) {
                        final block = blocks[index];

                        return GestureDetector(
                          onDoubleTap: () async {
                            await _sendNotification(block.label);
                          },
                          child: NotificationBlock(
                            key: _tileKeys[index],
                            label: block.label,
                            imagePath: block.image,
                            isLocalAsset: block.isLocalAsset,
                            isActive: index == _activeIndex,
                            onSelect: () => _selectTile(index),
                            customWidth: tileWidth,
                            customHeight: tileHeight,
                            customIconSize: iconSize,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            if (JoystickController().active)
              Positioned(
                bottom: 5,
                child: SlideTransition(
                  position: _joystickAnimation,
                  child: JoystickButton(
                    onUp: () => _moveSelection('up'),
                    onDown: () => _moveSelection('down'),
                    onLeft: () => _moveSelection('left'),
                    onRight: () => _moveSelection('right'),
                    onOk: () async {
                      final selected = blocks[_activeIndex];
                      await _sendNotification(selected.label);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
