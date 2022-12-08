import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/spring_translation_animation.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/components/letter_block_contents.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';
import 'package:studychinesetoday/utils/enums/answer_state.dart';
import '../../../configs/app_colors.dart';
import '../../../models/word_data.dart';
import 'components/bottom_buttons.dart';
import 'components/landing_area.dart';
import 'components/letter_block.dart';

class SentenceScramblerMain extends ConsumerStatefulWidget {
  const SentenceScramblerMain({Key? key}) : super(key: key);

  @override
  ConsumerState<SentenceScramblerMain> createState() =>
      _SentenceScramblerMainState();
}

class _SentenceScramblerMainState extends ConsumerState<SentenceScramblerMain> {
  List<WordData> masterSentence = [
    const WordData(english: 'apples', character: "", pinyin: ""),
    const WordData(english: 'are', character: "", pinyin: ""),
    const WordData(english: "very", character: "", pinyin: ""),
    const WordData(english: "delicious", character: "", pinyin: "")
  ];

  bool _isSetUpComplete = false;

  bool _hasAnimatedToCorrectPosition = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

    _setUp(notifier);

    int numberBlocksToAnimateBack = 0;

    List<SentenceWord> animatingWords = [];

    if (state.recallDroppedWord) {
      for (var w in state.currentSentence) {
        if (w.placedPosition == null && w.placedOffset != null) {
          animatingWords = [w];
          numberBlocksToAnimateBack = 1;
        }
      }
    }

    if (state.recallAllWords) {
      numberBlocksToAnimateBack = state.currentSentence
          .where((element) => element.placedOffset != null)
          .length;

      animatingWords = state.currentSentence
          .where((element) => element.placedOffset != null)
          .toList();
    }

    if (state.animateToCorrectPosition) {
      numberBlocksToAnimateBack = state.currentSentence.length;
      animatingWords = state.currentSentence;
    }
    if (state.answerState == AnswerState.incorrect) {
    Future.delayed(Duration(milliseconds: 1000), () {


        if (mounted) {
          notifier.showCorrectSentence(runAnimation: true);
        }


    });
    }

    return IgnorePointer(
      ignoring: state.recallDroppedWord || state.recallAllWords,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text(
                'Sentence Scrambler',
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final biggest = constraints.biggest;
                return Container(
                  color: AppColors.lightGrey,
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(0, -1.0),
                        child: SizedBox(
                          width: biggest.width,
                          height: biggest.height * 0.40,
                          child: const LandingArea(),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.10),
                        child: SizedBox(
                          height: biggest.height * 0.40,
                          width: double.infinity,
                          child: Wrap(
                            spacing: 22,
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            children: List.generate(
                              state.currentSentence.length,
                              (index) => LetterBlock(
                                sentenceWord: state.currentSentence[index],
                                index: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            height: biggest.height * 0.20,
                            child: const BottomButtons()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ...List.generate(
            numberBlocksToAnimateBack,
            (index) {
              return SpringTranslationAnimation(
                startOffset: animatingWords.elementAt(index).placedOffset,
                endOffset: animatingWords.elementAt(index).originalOffset,
                animate: state.recallDroppedWord ||
                    state.recallAllWords ||
                    state.animateToCorrectPosition,
                animationCompleted: () {
                  if (state.recallDroppedWord) {
                    notifier.recallDroppedWord(recall: false);
                    notifier.recallAnimationCompleted(words: animatingWords);
                  }

                  if (state.recallAllWords) {
                    notifier.recallAllWords(recall: false);
                    notifier.recallAnimationCompleted(words: animatingWords);
                  }
                  if (state.animateToCorrectPosition) {
                    notifier.showCorrectSentence(runAnimation: false);
                  }
                },
                child: LetterBlockContents(
                  wordData: animatingWords.elementAt(index).wordData,
                  hideUI: false,
                  backgroundColor: state.animateToCorrectPosition
                      ? Colors.red
                      : AppColors.offWhite,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _setUp(SentenceScramblerNotifier managerNotifier) {
    if (!_isSetUpComplete) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        List<SentenceWord> fullSentence = [];
        for (int i = 0; i < masterSentence.length; i++) {
          fullSentence.add(SentenceWord(
              wordData: masterSentence.elementAt(i), correctPosition: i));
        }
        fullSentence.shuffle();
        managerNotifier.setCurrentSentence(sentence: fullSentence);
        _isSetUpComplete = true;
      });
    }
  }
}
