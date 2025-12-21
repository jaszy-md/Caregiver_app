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

  static const Offset contentOffset = Offset(-10, -6);
  static const Offset percentageOffset = Offset(0, 5);
  static const Offset nameOffset = Offset(0, 2);
  static const Offset labelOffset = Offset(0, 0);
  static const Offset iconOffset = Offset(0, 2);

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
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scale = Tween<double>(
      begin: 0.93,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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

    final rawName = stats?.displayName;
    final firstName =
        rawName != null && rawName.trim().isNotEmpty
            ? rawName.trim().split(' ').first
            : null;

    final nameText = firstName != null ? "$firstName's" : null;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: GestureDetector(
            onTap: () => context.go('/stats'),
            child: SizedBox(
              width: 145,
              height: 135,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 🎨 Achtergrond
                  Assets.images.statusWidget.image(
                    fit: BoxFit.fill,
                    width: 145,
                    height: 135,
                  ),

                  Transform.translate(
                    offset: contentOffset,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: percentageOffset,
                          child: Text(
                            percentageText,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF005159),
                            ),
                          ),
                        ),

                        if (nameText != null)
                          Transform.translate(
                            offset: nameOffset,
                            child: Text(
                              nameText,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 205, 143, 35),
                              ),
                            ),
                          ),

                        Transform.translate(
                          offset: labelOffset,
                          child: const Text(
                            'Week status',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Color(0xFF005159),
                            ),
                          ),
                        ),

                        Transform.translate(
                          offset: iconOffset,
                          child: Assets.images.graphUp.image(
                            width: 18,
                            height: 18,
                            fit: BoxFit.contain,
                          ),
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
