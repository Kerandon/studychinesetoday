import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShakeAnimation extends StatefulWidget {
  const ShakeAnimation({
    Key? key,
    required this.child,
    required this.animate,
    this.duration = 600,
    this.delay = 0,
  }) : super(key: key);

  final Widget child;
  final bool animate;
  final int duration;
  final int delay;

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shake;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.12), weight: 3),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.12, end: -0.08), weight: 5),
      TweenSequenceItem(
          tween: Tween<double>(begin: -0.08, end: 0.04), weight: 5),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.04, end: 0.00), weight: 6),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.90), weight: 7),
      TweenSequenceItem(tween: Tween<double>(begin: 0.90, end: 1.0), weight: 3),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ShakeAnimation oldWidget) {
    if (widget.animate) {
      Future.delayed(
        Duration(milliseconds: widget.delay),
        () {
          if (mounted) {
            _controller.forward();
          }
        },
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(_scale.value)
          ..rotateZ(_shake.value * math.pi)
          ..setEntry(3, 2, 0.008),
        child: widget.child,
      ),
    );
  }
}
