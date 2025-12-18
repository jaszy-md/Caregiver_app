import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/core/riverpod_providers/stats_context_provider.dart';

class WeekStateTile extends ConsumerStatefulWidget {
  const WeekStateTile({super.key});

  @override
  ConsumerState<WeekStateTile> createState() => _WeekStateTileState();
}

class _WeekStateTileState extends ConsumerState<WeekStateTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0.08, 0), // héél subtiel
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scale = Tween<double>(
      begin: 0.97,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // 🔑 start animatie NA eerste paint
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statsContextProvider);
    final percentage = stats?.weekPercentage;
    final percentageText = percentage != null ? '$percentage%' : '--%';

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: GestureDetector(
            onTap: () => context.go('/stats'),
            child: SizedBox(
              width: 140,
              height: 130,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Assets.images.statusWidget.image(
                    fit: BoxFit.fill,
                    width: 140,
                    height: 130,
                  ),
                  Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          percentageText,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF005159),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Week status',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF005159),
                          ),
                        ),
                        Assets.images.graphUp.image(
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
