import 'package:flutter/material.dart';

class PopBackAnimation extends StatefulWidget {
  const PopBackAnimation({
    Key? key,
    required this.child,
    required this.animate,
    this.duration = 350,
    this.delay,
    this.onAnimationComplete,
  }) : super(key: key);

  final Widget child;
  final bool animate;
  final int duration;
  final int? delay;
  final Function? onAnimationComplete;

  @override
  State<PopBackAnimation> createState() => _PopBackAnimationState();
}

class _PopBackAnimationState extends State<PopBackAnimation>
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
  void didUpdateWidget(covariant PopBackAnimation oldWidget) {
    if(widget.delay != null){
      Future.delayed(Duration(milliseconds: widget.delay!),(){
        if(mounted) {
          _runAnimation();
        }
      });
    }else {
      _runAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _runAnimation() {
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
