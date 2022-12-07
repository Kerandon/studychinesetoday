import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/spring_translation_animation.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/components/letter_block_contents.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);
    // final animationState = ref.watch(sentenceAnimationProvider);
    // final animationNotifier = ref.read(sentenceAnimationProvider.notifier);

    _setUp(notifier);

    return Stack(
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
        // Opacity(
        //   opacity: animationState.isAnimatingBackToPosition ? 1 : 0,
        //   child: SpringTranslationAnimation(
        //     startOffset: animationState.droppedPosition,
        //     endOffset: animationState.originalPosition,
        //     animate: animationState.animate &&
        //         animationState.isAnimatingBackToPosition,
        //     child: animationState.letterBlock,
        //     animationCompleted: () {
        //       animationNotifier.setAnimationStatus(isAnimatingBack: false);
        //     },
        //   ),
        // ),
        ...List.generate(
          state.currentSentence
              .where((element) => element.placedOffset != null)
              .length,
          (index) {
            List<SentenceWord> words = state.currentSentence
                .where((element) => element.placedOffset != null)
                .toList();

            print(
                'animate back ${words.length}  ${state.recallWords} ${words.elementAt(0).placedOffset} '
                    '${words.elementAt(0).originalOffset}');

            return SpringTranslationAnimation(
                startOffset: words.elementAt(index).placedOffset,
                endOffset: words.elementAt(index).originalOffset,
                animate: state.recallWords,
                animationCompleted: () {
                  print('ANIM COMPLETED');

                 notifier.recallWords(recall: false);

                 notifier.recallAnimationCompleted(words: words);
                },
                child: LetterBlockContents(
                  wordData: words.elementAt(index).wordData,
                  hideUI: false,
                ));
          },
        ),
      ],
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
