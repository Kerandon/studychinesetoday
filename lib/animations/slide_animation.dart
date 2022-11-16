import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/enums/slide_direction.dart';

class SlideAnimation extends StatefulWidget {
  const SlideAnimation({
    Key? key,
    required this.child,
    required this.animate,
    required this.slideDirection,
    required this.slideCompleted,
  }) : super(key: key);

  final Widget child;
  final bool animate;
  final SlideDirection slideDirection;
  final VoidCallback? slideCompleted;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  Offset finalEndOffset = const Offset(0, 0);
  double _randomOffsetSlide = 0;

  @override
  void initState() {
    _randomOffsetSlide = Random().nextInt(5) * 0.010;
    final isNegative = Random().nextBool();
    if (isNegative) {
      _randomOffsetSlide *= -1.020;
    }

    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            widget.slideCompleted?.call();
          }
        },
      );
    if (widget.animate) {
      _controller.forward();
    }

    double endTurn = Random().nextInt(10) * 0.0003;
    if (Random().nextBool()) {
      endTurn *= -1.0;
    }

    _rotation = Tween<double>(begin: 0, end: endTurn).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Offset endOffset;

    late final Animation<Offset> offsetAnimation;

    if (!widget.animate) {
      endOffset = finalEndOffset;
    } else {
      switch (widget.slideDirection) {
        case SlideDirection.left:
          endOffset = const Offset(1, 0);

          endOffset = Offset(endOffset.dx + _randomOffsetSlide,
              endOffset.dy + _randomOffsetSlide);
          finalEndOffset = endOffset;
          break;
        case SlideDirection.right:
          endOffset = const Offset(-1, 0);
          finalEndOffset = endOffset;
          break;
        case SlideDirection.none:
          endOffset = const Offset(0, 0);
          finalEndOffset = endOffset;
          break;
      }
    }

    offsetAnimation = Tween<Offset>(begin: const Offset(0, 0), end: endOffset)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

    return RotationTransition(
      turns: _rotation,
      child: SlideTransition(
        position: offsetAnimation,
        child: widget.child,
      ),
    );
  }
}
