import 'package:flutter/material.dart';

class PopInAnimation extends StatefulWidget {
  const PopInAnimation({
    Key? key,
    required this.child,
    required this.animate,
    this.duration = 350,
    this.onAnimationComplete,
  }) : super(key: key);

  final Widget child;
  final bool animate;
  final int duration;
  final Function? onAnimationComplete;

  @override
  State<PopInAnimation> createState() => _PopInAnimationState();
}

class _PopInAnimationState extends State<PopInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            widget.onAnimationComplete?.call();
          }
        },
      );

    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 7),
        TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 3)
      ],
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PopInAnimation oldWidget) {
    if (widget.animate) {
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
