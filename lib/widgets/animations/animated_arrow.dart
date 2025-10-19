import 'package:flutter/material.dart';
import 'package:care_link/gen/assets.gen.dart';

class AnimatedArrow extends StatefulWidget {
  final double width;
  final double height;
  final bool moveRight;
  final double offsetDistance;
  final Duration duration;

  const AnimatedArrow({
    super.key,
    this.width = 90,
    this.height = 90,
    this.moveRight = true,
    this.offsetDistance = 0.1,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedArrow> createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    final end =
        widget.moveRight
            ? Offset(widget.offsetDistance, 0)
            : Offset(0, widget.offsetDistance);

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Assets.images.arrow.image(
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
      ),
    );
  }
}
