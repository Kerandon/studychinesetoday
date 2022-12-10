import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studychinesetoday/configs/app_colors.dart';
import 'package:studychinesetoday/configs/constants_other.dart';
import '../../../../models/word_data.dart';

class LetterBlockContents extends StatefulWidget {
  const LetterBlockContents({
    super.key,
    required this.wordData,
    this.hideUI = false,
    this.addShadow = false,
    this.backgroundColor = AppColors.offWhite,
    this.flashColor,
  });

  final WordData wordData;
  final bool hideUI;
  final bool addShadow;
  final Color backgroundColor;
  final Color? flashColor;

  @override
  State<LetterBlockContents> createState() => _LetterBlockContentsState();
}

class _LetterBlockContentsState extends State<LetterBlockContents> {
  late Color _backgroundColor;

  @override
  void initState() {
    if (widget.flashColor != null) {
      _backgroundColor = widget.flashColor!;
      Timer(
        const Duration(milliseconds: 300),
        () {
          if (mounted) {
            _backgroundColor = widget.backgroundColor;
            setState(() {});
          }
        },
      );
    } else {
      _backgroundColor = widget.backgroundColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * kSentenceWordBlockWidth,
      height: size.height * kSentenceWordBlockHeight,
      decoration: widget.hideUI
          ? BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            )
          : BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(kRadius),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                if (widget.addShadow) ...[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.50),
                      offset: const Offset(5, 5),
                      blurRadius: 5)
                ],
              ],
            ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            widget.wordData.character,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: widget.hideUI ? Colors.transparent : Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}
