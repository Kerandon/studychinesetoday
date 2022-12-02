import 'package:flutter/material.dart';
import 'drop_zone.dart';

class LandingArea extends StatefulWidget {
  const LandingArea({
    super.key,
  });

  @override
  State<LandingArea> createState() => _LandingAreaState();
}

class _LandingAreaState extends State<LandingArea> {
  int numberOfWords = 4;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.lightBlue,
      child: Center(
        child: Container(
          color: Colors.white,
          width: size.width * 0.70,
          height: size.height * 0.20,
          child: Wrap(
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 12,
            children: List.generate(
              numberOfWords,
              (index) => const DropZone(),
            ),
          ),
        ),
      ),
    );
  }
}
