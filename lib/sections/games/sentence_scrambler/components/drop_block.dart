import 'package:flutter/material.dart';
import 'package:studychinesetoday/configs/app_theme.dart';
import 'package:studychinesetoday/configs/constants_other.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';

import '../../../../configs/app_colors.dart';
import '../../../../models/word_data.dart';

class DropBlock extends StatelessWidget {
  const DropBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WordData? wordData;
    final size = MediaQuery.of(context).size;

    return DragTarget<SentenceWord>(
      onWillAccept: (details) {
        return true;
      },
      onAccept: (details) {
        wordData = details.wordData;
      },
      builder: (context, _, __) {
        return FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            height: size.height * 0.08,
            width: size.width * 0.12,
            child: wordData == null
                ? Container(
                    decoration: BoxDecoration(
                        color: AppColors.mediumGrey,
                        borderRadius: BorderRadius.circular(kRadius)),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(kRadius)),
                    child: Center(
                      child: Text(
                        wordData!.english,
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
