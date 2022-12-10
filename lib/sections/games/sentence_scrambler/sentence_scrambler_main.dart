import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_block.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/sentence_scrambler_home_page.dart';
import 'data/sentences.dart';
import 'models/sentence.dart';

class SentenceScramblerMain extends ConsumerStatefulWidget {
  const SentenceScramblerMain({Key? key}) : super(key: key);

  @override
  ConsumerState<SentenceScramblerMain> createState() =>
      _SentenceScramblerMainState();
}

class _SentenceScramblerMainState extends ConsumerState<SentenceScramblerMain> {
  late Sentence masterSentence;

  bool _isSetUpComplete = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

    if (state.newSentence) {
      _isSetUpComplete = false;
    }

    _setUp(notifier);

    return SentenceScramblerHomePage(
      masterSentence: masterSentence,
    );
  }

  void _setUp(SentenceScramblerNotifier managerNotifier) {
    if (!_isSetUpComplete) {
      final random = Random().nextInt(sentences.length);
      masterSentence = sentences[random];
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          List<SentenceBlock> fullSentence = [];
          for (int i = 0; i < masterSentence.wordDataList.length; i++) {
            fullSentence.add(SentenceBlock(
                wordData: masterSentence.wordDataList.elementAt(i),
                correctPosition: i));
          }
          fullSentence.shuffle();
          managerNotifier.setCurrentSentence(sentence: fullSentence);
          _isSetUpComplete = true;
          managerNotifier.generateNewSentence(generate: false);
        },
      );
    }
  }
}
