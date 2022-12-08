import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/configs/constants_other.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';
import 'package:studychinesetoday/utils/enums/answer_state.dart';
import 'package:studychinesetoday/utils/methods_other.dart';
import '../../../../configs/app_colors.dart';
import '../../../../models/word_data.dart';
import '../providers/sentence_scrambler_manager.dart';

class DropBlock extends ConsumerStatefulWidget {
  const DropBlock({
    super.key,
    required this.position,
  });

  final int position;

  @override
  ConsumerState<DropBlock> createState() => _DropBlockState();
}

class _DropBlockState extends ConsumerState<DropBlock> {
  final _widgetKey = GlobalKey();
  Offset _offsetPosition = const Offset(0, 0);
  WordData? wordData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final notifier = ref.read(sentenceScramblerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _offsetPosition = getWidgetGlobalPosition(positionKey: _widgetKey);
      },
    );

    return DragTarget<SentenceWord>(
      onWillAccept: (word) {
        return true;
      },
      onAccept: (word) {
        wordData = word.wordData;
        notifier.wordAccepted(
          sentenceWord: SentenceWord(
            wordData: word.wordData,
            correctPosition: word.correctPosition,
            placedPosition: widget.position,
            placedOffset: _offsetPosition,
          ),
        );
      },
      builder: (context, _, __) {
        return FittedBox(
          key: _widgetKey,
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
                : Consumer(
                    builder: (_, WidgetRef ref, ___) {
                      final sentenceState =
                          ref.watch(sentenceScramblerProvider);

                      if (sentenceState.recallAllWords) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (timeStamp) {
                            wordData = null;
                            setState(() {});
                          },
                        );
                      }

                      Color tileColor = _setResultColor(sentenceState);

                      return Container(
                        decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: BorderRadius.circular(kRadius)),
                        child: Center(
                          child: Text(
                            wordData!.english,
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Color _setResultColor(SentenceScramblerState sentenceState) {
    Color tileColor = Colors.amber;

    if (sentenceState.allPlaced) {
      if (sentenceState.answerState == AnswerState.correct) {
        tileColor = Colors.green;
      }
      if (sentenceState.answerState == AnswerState.incorrect) {
        tileColor = Colors.red;
      }
    }
    return tileColor;
  }
}
