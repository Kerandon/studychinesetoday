import 'package:flutter/material.dart';
import 'drop_block.dart';

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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          spacing: 12,
          children: List.generate(
            numberOfWords,
            (index) => const DropBlock(),
          ),
        ),
      ),
    );
  }
}
