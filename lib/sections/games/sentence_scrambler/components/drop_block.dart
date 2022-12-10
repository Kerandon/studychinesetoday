import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/pop_back_animation.dart';
import 'package:studychinesetoday/animations/spin_animation.dart';
import 'package:studychinesetoday/animations/spring_translation_animation.dart';
import 'package:studychinesetoday/configs/constants_other.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/components/letter_block_contents.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_block.dart';
import 'package:studychinesetoday/utils/enums/answer_state.dart';
import 'package:studychinesetoday/utils/methods_other.dart';
import '../../../../animations/shake_animation.dart';
import '../../../../configs/app_colors.dart';
import '../../../../models/word_data.dart';
import '../providers/sentence_scrambler_manager.dart';

class DropBlock extends ConsumerStatefulWidget {
  const DropBlock({
    super.key,
    required this.position,
    required this.hintText,
  });

  final int position;
  final String hintText;

  @override
  ConsumerState<DropBlock> createState() => _DropBlockState();
}

class _DropBlockState extends ConsumerState<DropBlock> {
  final _widgetKey = GlobalKey();
  Offset _offsetPosition = const Offset(0, 0);
  WordData? wordData;
  bool _animateOnStart = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

    return state.animateToCorrectPosition
        ? const SizedBox()
        : CustomTranslationAnimation(
            beginOffset: Offset(0, size.height * -0.50),
            animate: _animateOnStart,
            onAnimationComplete: () {
              _animateOnStart = false;
              _offsetPosition =
                  getWidgetGlobalPosition(positionKey: _widgetKey);
            },
            child: DragTarget<SentenceBlock>(
              onWillAccept: (word) {
                bool canAccept = true;

                canAccept = !state.currentSentence.any(
                    (element) => element.placedPosition == widget.position);
                return canAccept;
              },
              onAccept: (word) {
                wordData = word.wordData;
                notifier.wordAccepted(
                  sentenceWord: SentenceBlock(
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
                    width: size.width * kSentenceWordBlockWidth,
                    height: size.height * kSentenceWordBlockHeight,
                    child: wordData == null
                        ? Container(
                            decoration: BoxDecoration(
                                color: AppColors.mediumGrey,
                                borderRadius: BorderRadius.circular(kRadius)),
                      child: Center(child: Text(widget.hintText)),
                          )
                        : Consumer(
                            builder: (_, WidgetRef ref, ___) {
                              final state =
                                  ref.watch(sentenceScramblerProvider);

                              if (state.recallAllWords) {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (timeStamp) {
                                    wordData = null;
                                    setState(() {});
                                  },
                                );
                              }

                              Color backgroundColor = _setResultColor(state);

                              return PopInAnimation(
                                animate:
                                    state.answerState == AnswerState.incorrect,
                                onAnimationComplete: () {
                                  notifier.showCorrectSentence(
                                      screenSize: size);
                                },
                                child: ShakeAnimation(
                                  animateOnDemand: false,
                                  animateOnStart: true,
                                  child: SpinAnimation(
                                    animate: state.answerState ==
                                        AnswerState.correct,
                                    child: CustomTranslationAnimation(
                                      delay: 800,
                                      animate: state.answerState ==
                                          AnswerState.correct,
                                      endOffset: Offset(0, size.height * 0.20),
                                      addSpringEffect: true,
                                      child: LetterBlockContents(
                                        wordData: wordData!,
                                        backgroundColor: backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                );
              },
            ),
          );
  }

  Color _setResultColor(SentenceScramblerState sentenceState) {
    Color tileColor = Colors.tealAccent;

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
