import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomTranslationAnimation extends StatefulWidget {
  const CustomTranslationAnimation({
    Key? key,
    required this.child,
    required this.animate,
    this.beginOffset,
    this.endOffset,
    this.addSpringEffect = false,
    this.onAnimationComplete,
    this.delay,
  }) : super(key: key);

  final Widget child;
  final bool animate;
  final Offset? beginOffset;
  final Offset? endOffset;
  final bool addSpringEffect;
  final VoidCallback? onAnimationComplete;
  final int? delay;

  @override
  State<CustomTranslationAnimation> createState() =>
      _CustomTranslationAnimationState();
}

class _CustomTranslationAnimationState extends State<CustomTranslationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final SpringSimulation _springSimulation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    const spring = SpringDescription(mass: 50, stiffness: 0.30, damping: 1);
    _springSimulation = SpringSimulation(spring, 0, 1, -20);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTranslationAnimation oldWidget) {
    if(widget.delay == null) {
      _runAnimation();
    }else{
      Future.delayed(Duration(milliseconds: widget.delay!), (){
        if(mounted){
          _runAnimation();
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _runAnimation() {
    if (widget.animate && !_controller.isAnimating) {
      _controller.reset();
      if (widget.addSpringEffect) {
        _controller.animateWith(_springSimulation);
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> animation = Tween<Offset>(
            begin: widget.beginOffset ?? const Offset(0, 0),
            end: widget.endOffset ?? const Offset(0, 0))
        .animate(_controller);

    return widget.animate
        ? AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform(
              transform: Matrix4.translationValues(
                  animation.value.dx, animation.value.dy, 0),
              child: widget.child,
            ),
          )
        : widget.child;
  }
}
