import 'package:care_link/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:care_link/data/patient_notifications.dart';
import 'package:care_link/widgets/buttons/notification_block.dart';
import 'package:care_link/widgets/buttons/direction_controller.dart';

class PatientNotificationsSection extends StatefulWidget {
  final ValueChanged<String> onTileSelected;

  const PatientNotificationsSection({super.key, required this.onTileSelected});

  @override
  State<PatientNotificationsSection> createState() =>
      _PatientNotificationsSectionState();
}

class _PatientNotificationsSectionState
    extends State<PatientNotificationsSection>
    with TickerProviderStateMixin {
  int _activeIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<GlobalKey> _tileKeys = List.generate(
    patientNotifications.length,
    (_) => GlobalKey(),
  );

  late final AnimationController _joystickController;
  late final Animation<Offset> _joystickAnimation;

  @override
  void initState() {
    super.initState();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _joystickController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _joystickController.dispose();
    super.dispose();
  }

  void _selectTile(int newIndex) {
    if (newIndex < 0 || newIndex >= patientNotifications.length) return;

    setState(() => _activeIndex = newIndex);
    widget.onTileSelected(patientNotifications[newIndex]['label']!);

    // Auto scrol
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _tileKeys[newIndex].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          alignment: 0.5,
        );
      }
    });
  }

  void _moveSelection(String direction) {
    const columns = 3;
    int newIndex = _activeIndex;

    switch (direction) {
      case 'up':
        newIndex -= columns;
        if (newIndex < 0) newIndex = patientNotifications.length - 1;
        break;
      case 'down':
        newIndex += columns;
        if (newIndex >= patientNotifications.length) newIndex = 0;
        break;
      case 'left':
        newIndex--;
        if (newIndex < 0) newIndex = patientNotifications.length - 1;
        break;
      case 'right':
        newIndex++;
        if (newIndex >= patientNotifications.length) newIndex = 0;
        break;
    }

    _selectTile(newIndex);
  }

  @override
  Widget build(BuildContext context) {
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
            RepaintBoundary(
              child: Transform.scale(
                scale: ipadImageScale,
                child: Assets.images.ipad.image(
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.high,
                ),
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
                      itemCount: patientNotifications.length,
                      itemBuilder: (context, index) {
                        final block = patientNotifications[index];
                        return NotificationBlock(
                          key: _tileKeys[index],
                          label: block['label']!,
                          imagePath: block['image']!,
                          isActive: index == _activeIndex,
                          onSelect: () => _selectTile(index),
                          customWidth: tileWidth,
                          customHeight: tileHeight,
                          customIconSize: iconSize,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // joystick
            Positioned(
              bottom: 5,
              child: SlideTransition(
                position: _joystickAnimation,
                child: DirectionController(
                  onUp: () => _moveSelection('up'),
                  onDown: () => _moveSelection('down'),
                  onLeft: () => _moveSelection('left'),
                  onRight: () => _moveSelection('right'),
                  onOk: () {
                    debugPrint(
                      "OK pressed on ${patientNotifications[_activeIndex]['label']}",
                    );
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
