import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/utils/enums/flip_stage.dart';

class FlipAnimation extends ConsumerStatefulWidget {
  const FlipAnimation({
    Key? key,
    required this.child,
    required this.animate,
    this.reverseFlip = false,
    this.flipCallback,
    this.duration = 1100,
    this.delay = 0,
  }) : super(key: key);

  final Widget child;
  final bool animate;
  final bool reverseFlip;
  final Function(FlipStage)? flipCallback;
  final int duration;
  final int delay;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FlipAnimationState();
}

class FlipAnimationState extends ConsumerState<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;
  bool _notifiedFullFlipCompleted = false;
  bool _notifiedReverseFlipCompleted = false;
  bool _notifiedHalfFlipCompletedForward = false;
  bool _notifiedHalfFlipCompletedReversed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_notifiedFullFlipCompleted) {
          widget.flipCallback?.call(FlipStage.full);
          _notifiedFullFlipCompleted = true;
          _notifiedReverseFlipCompleted = false;
        }
        if (status == AnimationStatus.dismissed && !_notifiedReverseFlipCompleted) {
          widget.flipCallback?.call(FlipStage.reverseCompleted);
          _notifiedReverseFlipCompleted = true;
          _notifiedFullFlipCompleted = false;
        }
      });

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlipAnimation oldWidget) {
    Future.delayed(
      Duration(milliseconds: widget.delay),
      () {
        if (mounted) {
          if (widget.animate) {
            _controller.forward();
          }
          if (widget.reverseFlip) {
            _controller.reverse();
          }
        }
      },
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, index) {
        if (_controller.status == AnimationStatus.forward && _controller.value > 0.50 && !_notifiedHalfFlipCompletedForward) {
           widget.flipCallback?.call(FlipStage.halfForward);
          _notifiedHalfFlipCompletedForward = true;
           _notifiedHalfFlipCompletedReversed = false;
        }
        if (_controller.status == AnimationStatus.reverse && _controller.value < 0.50 && !_notifiedHalfFlipCompletedReversed) {
           widget.flipCallback?.call(FlipStage.halfBack);
          _notifiedHalfFlipCompletedReversed = true;
           _notifiedHalfFlipCompletedForward = false;

        }

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0010)
            ..rotateY(_flipAnimation.value * pi),
          child: widget.child,
        );
      },
    );
  }
}
