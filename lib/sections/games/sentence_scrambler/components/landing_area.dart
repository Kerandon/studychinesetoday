import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';
import 'drop_block.dart';

class LandingArea extends ConsumerWidget {
  const LandingArea({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int numberOfWords =
        ref.watch(sentenceScramblerProvider).currentSentence.length;

    List<String> _grammar = ['Subject', 'Adverb', 'Adjective', 'Verb'];

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          spacing: 12,
          children: List.generate(
            numberOfWords,
            (index) => DropBlock(
              position: index,
              hintText: _grammar[index],
            ),
          ),
        ),
      ),
    );
  }
}
