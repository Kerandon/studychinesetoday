import 'dart:math';

import 'package:flutter/material.dart';

class FlyInAnimation extends StatefulWidget {
  const FlyInAnimation({
    Key? key,
    required this.child,
    this.animateOnDemand = false,
    this.onAnimationComplete,
  }) : super(key: key);

  final Widget child;
  final bool animateOnDemand;
  final VoidCallback? onAnimationComplete;

  @override
  State<FlyInAnimation> createState() => _FlyInAnimationState();
}

class _FlyInAnimationState extends State<FlyInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _scale = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    _rotate = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlyInAnimation oldWidget) {
    if (widget.animateOnDemand && !_controller.isAnimating) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.animateOnDemand
        ? AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(_scale.value)
                ..rotateY(_rotate.value * pi)
                ..rotateZ(_rotate.value * pi)
                ..setEntry(3, 2, 0.008),
              child: widget.child,
            ),
          )
        : widget.child;
  }
}
