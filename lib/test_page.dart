import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';


class Test3 extends StatefulWidget {
  const Test3({Key? key}) : super(key: key);

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> with SingleTickerProviderStateMixin {
  final _positionKey = GlobalKey();

  late AnimationController _controller;
  Offset? startOffset;
  bool _isAnimatingBackToPosition = false;
  late final SpringSimulation springSimulation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _isAnimatingBackToPosition = false;
              setState(() {});
            }
          });

    const spring = SpringDescription(mass: 80, stiffness: 0.5, damping: 1);

    springSimulation = SpringSimulation(spring, 0, 1, -20);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _animateToDropPosition({required Offset offset}) {
    setState(() {
      startOffset = offset;
      _isAnimatingBackToPosition = true;
      _controller.reset();
      _controller.animateWith(springSimulation);
    });
  }

  @override
  Widget build(BuildContext context) {
    Offset? originalPosition;
    RenderBox? renderBox =
        _positionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      originalPosition = renderBox.localToGlobal(Offset.zero);
    }
    Animation<Offset> animation =
        Tween<Offset>(begin: startOffset ?? const Offset(0,0), end: originalPosition ?? const Offset(0, 0))
            .animate(_controller);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child: Stack(
        children: [
          _isAnimatingBackToPosition
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Transform(
                    transform: Matrix4.translationValues(
                        animation.value.dx, animation.value.dy, 0),
                    child: const Box()
                  ),
                )
              : const SizedBox(),
          Center(
            child: _isAnimatingBackToPosition
                ? const SizedBox()
                : Draggable(
                    childWhenDragging: SizedBox(
                      key: _positionKey,
                      height: 100,
                      width: 100,
                    ),
                    feedback: const Box(),
                    child: const Box(),
                    onDragEnd: (details) {
                      _animateToDropPosition(offset: details.offset);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Box extends StatelessWidget {
  const Box({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.lime,
    );
  }
}
