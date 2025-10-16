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

  late final AnimationController _joystickController;
  late final Animation<Offset> _joystickAnimation;

  bool _firstFrameDrawn = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() => _firstFrameDrawn = true);
      _joystickController.forward(from: 0);

      if (patientNotifications.isNotEmpty) {
        widget.onTileSelected(patientNotifications[0]['label']!);
      }
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const scrollPadding = 60.0;
      const tileHeight = 80.0;
      final targetOffset = (newIndex ~/ 3) * (tileHeight + 8);

      if (!_scrollController.hasClients) return;

      final currentScroll = _scrollController.offset;
      final viewportHeight = _scrollController.position.viewportDimension;

      if (targetOffset < currentScroll + scrollPadding) {
        _scrollController.animateTo(
          (targetOffset - scrollPadding).clamp(0, double.infinity),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      } else if (targetOffset + tileHeight >
          currentScroll + viewportHeight - scrollPadding) {
        _scrollController.animateTo(
          (targetOffset - viewportHeight + tileHeight + scrollPadding).clamp(
            0,
            _scrollController.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
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
        if (newIndex < 0) {
          newIndex =
              patientNotifications.length -
              (columns - (_activeIndex % columns));
          if (newIndex >= patientNotifications.length) {
            newIndex = patientNotifications.length - 1;
          }
        }
        break;
      case 'down':
        newIndex += columns;
        if (newIndex >= patientNotifications.length) {
          newIndex = _activeIndex % columns;
        }
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
    final double verticalPadding = ipadHeight * 0.140;
    final double spacing = ipadWidth * 0.02;
    final double gridWidth = ipadWidth - (horizontalPadding * 2);
    final double tileWidth = (gridWidth - spacing * 2) / 3;
    final double tileHeight = tileWidth * 0.8;
    final double iconSize = tileWidth * 0.55;

    final double ipadImageScale =
        width < 380
            ? 1.12
            : width < 430
            ? 1.06
            : 1.0;

    return RepaintBoundary(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: ipadImageScale,
              child: Image.asset(
                'assets/images/ipad-container-5.png',
                fit: BoxFit.contain,
                width: ipadWidth,
                height: ipadHeight,
                gaplessPlayback: true,
                filterQuality: FilterQuality.high,
              ),
            ),

            Positioned(
              top: verticalPadding - 30,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_firstFrameDrawn,
                child: AnimatedOpacity(
                  opacity: _firstFrameDrawn ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    "DUBBEL KLIK OM TE VERSTUREN",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF004F54),
                      letterSpacing: 0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
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

            if (_firstFrameDrawn)
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
