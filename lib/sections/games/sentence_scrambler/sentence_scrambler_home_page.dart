import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';

import '../../../animations/spring_translation_animation.dart';
import '../../../configs/app_colors.dart';
import 'components/bottom_buttons.dart';
import 'components/landing_area.dart';
import 'components/letter_block.dart';
import 'components/letter_block_contents.dart';
import 'models/sentence.dart';
import 'models/sentence_block.dart';

class SentenceScramblerHomePage extends ConsumerWidget {
  const SentenceScramblerHomePage({
    super.key,
    required this.masterSentence,
  });

  final Sentence masterSentence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

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
                        child: Text(
                          masterSentence.english,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
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
                              (index) {
                                return LetterBlock(
                                  sentenceWord: state.currentSentence[index],
                                  index: index,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: biggest.height * 0.20,
                          child: const BottomButtons(),
                        ),
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
                addSpringEffect: !state.animateToCorrectPosition,
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
                  backgroundColor: AppColors.offWhite,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
