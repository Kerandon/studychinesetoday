import 'package:flutter/material.dart';
import 'package:studychinesetoday/configs/app_colors.dart';
import 'package:studychinesetoday/configs/constants_other.dart';

import '../../../../models/word_data.dart';

class LetterBlockContents extends StatelessWidget {
  const LetterBlockContents({
    super.key,
    required this.wordData,
    this.hideUI = false,
    this.addShadow = false,
    this.animatingBackWidget = false,
  });

  final WordData wordData;
  final bool hideUI;
  final bool addShadow;
  final bool animatingBackWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hideUI && !animatingBackWidget
          ? BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            )
          : BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(kRadius),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                if (addShadow) ...[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.50),
                      offset: const Offset(5, 5),
                      blurRadius: 5)
                ],
              ],
            ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          wordData.english,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: hideUI ? Colors.transparent : Colors.black,
              ),
        ),
      ),
    );
  }
}
