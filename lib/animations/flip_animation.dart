import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../sections/games/flashcards/flashcard_provider.dart';

class FlipAnimation extends ConsumerStatefulWidget {
  const FlipAnimation({
    Key? key,
    required this.child,
    required this.index,
    required this.animate,
    this.reverseFlip = false,
    this.halfFlipCompleted,
    this.fullFlipCompleted,
    this.reverseFlipHalfCompleted,
    this.reverseFlipCompleted,
  }) : super(key: key);

  final Widget child;
  final int index;
  final bool animate;
  final bool reverseFlip;
  final VoidCallback? halfFlipCompleted;
  final VoidCallback? fullFlipCompleted;
  final VoidCallback? reverseFlipHalfCompleted;
  final VoidCallback? reverseFlipCompleted;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FlipAnimationState();
}

class FlipAnimationState extends ConsumerState<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;
  bool _animationHasRun = false;
  bool _notifiedHasHalfFlipped = false;
  bool _notifiedHasReverseHalfFlipped = false;
  bool _notifiedHasFullFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1900),
      vsync: this,
    );

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
    if (widget.reverseFlip) {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, index) {
        if (_controller.value >= 0.50) {
          if (!_notifiedHasHalfFlipped) {
            widget.halfFlipCompleted?.call();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref
                  .read(flashcardProvider.notifier)
                  .setHasHalfFlipped(halfFlipped: {widget.index: true});
              _notifiedHasHalfFlipped = true;
            });
          }
        }
        if (!_notifiedHasFullFlipped) {
          if (_controller.value == 1.0) {
            widget.fullFlipCompleted?.call();
            _notifiedHasFullFlipped = true;
          }
        }
        if (widget.reverseFlip) {
          if (_controller.value < 0.50) {
            if (!_notifiedHasReverseHalfFlipped) {
              widget.reverseFlipHalfCompleted?.call();
              _notifiedHasReverseHalfFlipped = true;
            }
          }
          if (_controller.value == 0.0) {
            widget.reverseFlipCompleted?.call();
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
