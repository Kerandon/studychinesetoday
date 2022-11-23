import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/games/flashcards/flashcard_provider.dart';

class FlipAnimation extends ConsumerStatefulWidget {
  const FlipAnimation({
    Key? key,
    required this.child,
    required this.index,
    required this.animate,
    this.flipCompleted,
  }) : super(key: key);

  final Widget child;
  final int index;
  final bool animate;
  final VoidCallback? flipCompleted;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FlipAnimationState();
}

class FlipAnimationState extends ConsumerState<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;
  bool _animationHasRun = false;
  bool _notifiedHasFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.flipCompleted?.call();
        }
      });

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlipAnimation oldWidget) {
    if (widget.animate && !_animationHasRun) {
      _controller.forward();
      _animationHasRun = true;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, index) {
        if (_controller.value >= 0.50) {
          if (!_notifiedHasFlipped) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref
                  .read(flashcardProvider.notifier)
                  .setHasHalfFlipped(halfFlipped: {widget.index: true});
              _notifiedHasFlipped = true;
            });
          }
        }
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0008)
            ..rotateY(_flipAnimation.value * pi),
          child: widget.child,
        );
      },
    );
  }
}
