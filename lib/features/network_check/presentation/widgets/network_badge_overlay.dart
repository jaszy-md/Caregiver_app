import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:care_link/features/network_check/state/network_status_notifier.dart';
import 'package:care_link/gen/assets.gen.dart';

class NetworkBadgeOverlay extends StatefulWidget {
  final Widget child;
  const NetworkBadgeOverlay({super.key, required this.child});

  @override
  State<NetworkBadgeOverlay> createState() => _NetworkBadgeOverlayState();
}

class _NetworkBadgeOverlayState extends State<NetworkBadgeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse-animatie: icoon ademt rustig in en uit
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _sizeAnimation = Tween<double>(
      begin: 42,
      end: 32,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<NetworkStatusNotifier>().isOnline;

    return Stack(
      children: [
        widget.child,

        if (!isOnline)
          Positioned(
            top: 80,
            right: 16,
            child: AnimatedBuilder(
              animation: _sizeAnimation,
              builder: (_, __) {
                return Assets.images.noInternet.image(
                  height: _sizeAnimation.value,
                  width: _sizeAnimation.value,
                  color: Colors.white,
                );
              },
            ),
          ),
      ],
    );
  }
}
