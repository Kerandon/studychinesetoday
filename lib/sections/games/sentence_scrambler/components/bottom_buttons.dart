import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';
import 'package:studychinesetoday/utils/enums/answer_state.dart';

import '../../../../configs/app_colors.dart';

class BottomButtons extends ConsumerWidget {
  const BottomButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

    bool canRecall = false;

    if (state.answerState == AnswerState.notAnswered) {
      if (state.currentSentence
          .any((element) => element.placedPosition != null) && !state.recallAllWords) {
        canRecall = true;
      }
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: state.allPlaced
                    ? () {
                        notifier.checkAnswer();
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Check Answer',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.05),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: canRecall
                        ? () {
                            notifier.recallAllWords(recall: true);
                          }
                        : null,
                    icon: Icon(
                      Icons.refresh_outlined,
                      color: AppColors.darkGrey,
                    ))),
          ],
        ),
      ),
    );
  }
}
