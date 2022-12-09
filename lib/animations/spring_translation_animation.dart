import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringTranslationAnimation extends StatefulWidget {
  const SpringTranslationAnimation({
    Key? key,
    required this.child,
    required this.animate,
    this.startOffset,
    this.endOffset,
    this.animationCompleted,
  }) : super(key: key);

  final Widget child;
  final Offset? startOffset;
  final Offset? endOffset;
  final bool animate;
  final VoidCallback? animationCompleted;

  @override
  State<SpringTranslationAnimation> createState() =>
      _SpringTranslationAnimationState();
}

class _SpringTranslationAnimationState extends State<SpringTranslationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final SpringSimulation _springSimulation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.animationCompleted?.call();
        }
      });

    // const spring = SpringDescription(mass: 60, stiffness: 1, damping: 1);
    // _springSimulation = SpringSimulation(spring, 0, 1, -20);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SpringTranslationAnimation oldWidget) {
    if (widget.animate) {
      _controller.reset();
      _controller.forward();
      //_controller.animateWith(_springSimulation);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> animation = Tween<Offset>(
            begin: widget.startOffset ?? const Offset(0, 0),
            end: widget.endOffset ?? const Offset(0, 0))
        .animate(_controller);

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform(
            transform: Matrix4.translationValues(
                animation.value.dx, animation.value.dy, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
