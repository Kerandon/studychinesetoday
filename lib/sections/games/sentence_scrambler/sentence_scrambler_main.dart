import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/spring_transition_animation.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/sentence_scrambler_provider.dart';
import '../../../models/word_data.dart';
import 'bottom_buttons.dart';
import 'landing_area.dart';
import 'letter_block.dart';

class SentenceScramblerMain extends ConsumerStatefulWidget {
  const SentenceScramblerMain({Key? key}) : super(key: key);

  @override
  ConsumerState<SentenceScramblerMain> createState() =>
      _SentenceScramblerMainState();
}

class _SentenceScramblerMainState extends ConsumerState<SentenceScramblerMain> {
  List<WordData> sentence = [
    const WordData(english: 'apples', character: "", pinyin: ""),
    const WordData(english: 'are', character: "", pinyin: ""),
    const WordData(english: "very", character: "", pinyin: ""),
    const WordData(english: "delicious", character: "", pinyin: "")
  ];

  @override
  Widget build(BuildContext context) {
    final sentenceScramblerState = ref.watch(sentenceAnimationProvider);
    final sentenceScramblerNotifier =
        ref.read(sentenceAnimationProvider.notifier);

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
                color: Colors.amber,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: biggest.height * 0.20,
                        child: LandingArea(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        spacing: 22,
                        runAlignment: WrapAlignment.center,
                        children: List.generate(
                          sentence.length,
                          (index) => LetterBlock(
                            wordData: sentence[index],
                            index: index,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          height: biggest.height * 0.20,
                          child: BottomButtons()),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Opacity(
          opacity: sentenceScramblerState.isAnimatingBackToPosition ? 1 : 0,
          child: CustomAnimation(
            startOffset: sentenceScramblerState.droppedPosition,
            endOffset: sentenceScramblerState.originalPosition,
            animate: sentenceScramblerState.animate &&
                sentenceScramblerState.isAnimatingBackToPosition,
            child: sentenceScramblerState.letterBlock,
            animationCompleted: () {
              sentenceScramblerNotifier.setAnimationStatus(
                  isAnimatingBack: false);
            },
          ),
        )
      ],
    );
  }
}
