import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/components/letter_block_contents.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_block.dart';
import '../../../animations/spring_translation_animation.dart';
import '../../../configs/app_colors.dart';
import '../../../models/word_data.dart';
import 'components/bottom_buttons.dart';
import 'components/landing_area.dart';
import 'components/letter_block.dart';
import 'data/sentences.dart';
import 'models/sentence.dart';

class SentenceScramblerMain extends ConsumerStatefulWidget {
  const SentenceScramblerMain({Key? key}) : super(key: key);

  @override
  ConsumerState<SentenceScramblerMain> createState() =>
      _SentenceScramblerMainState();
}

class _SentenceScramblerMainState extends ConsumerState<SentenceScramblerMain> {
  late final Sentence masterSentence;

  bool _isSetUpComplete = false;

  @override
  void initState() {
    final random = Random().nextInt(sentences.length);
    masterSentence = sentences[random];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

    _setUp(notifier);

    List<SentenceBlock> animatingWords = [];

    if (state.recallDroppedWord) {
      for (var w in state.currentSentence) {
        if (w.placedPosition == null && w.placedOffset != null) {
          animatingWords = [w];
        }
      }
    }

    if (state.recallAllWords) {
      animatingWords = state.currentSentence
          .where((element) => element.placedOffset != null)
          .toList();
    }

    if (state.animateToCorrectPosition) {
      animatingWords = state.currentSentence;
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
                        alignment: const Alignment(0, -0.85),
                        child: Text(masterSentence.english),
                      ),
                      Align(
                        alignment: const Alignment(0, -0.80),
                        child: SizedBox(
                          width: biggest.width,
                          height: biggest.height * 0.40,
                          child: const LandingArea(),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.50),
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
            animatingWords.length,
            (index) {
              return CustomTranslationAnimation(
                addSpringEffect: true,
                beginOffset: animatingWords.elementAt(index).placedOffset,
                endOffset: animatingWords.elementAt(index).originalOffset,
                animate: state.recallDroppedWord ||
                    state.recallAllWords ||
                    state.animateToCorrectPosition,
                onAnimationComplete: () {
                  if (state.recallDroppedWord) {
                    notifier.recallDroppedWord(recall: false);
                    notifier.recallAnimationCompleted(words: animatingWords);
                  }

                  if (state.recallAllWords) {
                    notifier.recallAllWords(recall: false);
                    notifier.recallAnimationCompleted(words: animatingWords);
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
        List<SentenceBlock> fullSentence = [];
        for (int i = 0; i < masterSentence.wordDataList.length; i++) {
          fullSentence.add(SentenceBlock(
              wordData: masterSentence.wordDataList.elementAt(i),
              correctPosition: i));
        }
        fullSentence.shuffle();
        managerNotifier.setCurrentSentence(sentence: fullSentence);
        _isSetUpComplete = true;
      });
    }
  }
}
