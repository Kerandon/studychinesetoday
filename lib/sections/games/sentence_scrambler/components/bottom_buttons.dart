import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_manager.dart';

class BottomButtons extends ConsumerWidget {
  const BottomButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managerState = ref.watch(sentenceScramblerProvider);
    final managerNotifier = ref.read(sentenceScramblerProvider.notifier);
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
                onPressed: managerState.allPlaced ? () {
                  managerNotifier.checkAnswer();
                } : null,
                child: Text(
                  'check answer',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed:() {
                  managerNotifier.recallWords(recall: true);
                },
                child: Text(
                  'recall words',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
