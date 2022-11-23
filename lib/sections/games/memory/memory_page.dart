import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/components/app/loading_screen.dart';
import 'package:studychinesetoday/state_management/topics_data.dart';

import '../../../models/word_data.dart';
import '../../../utils/methods.dart';
import '../../games/memory/grid_content.dart';
import 'memory_provider.dart';
import 'memory_word.dart';

class MemoryPage extends ConsumerStatefulWidget {
  const MemoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends ConsumerState<MemoryPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final topicsDataState = ref.read(topicsDataProvider);
      final memoryNotifier = ref.read(memoryProvider.notifier);

      _setUp(topicsDataState: topicsDataState, memoryNotifier: memoryNotifier);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allWordsProvider = FutureProvider.autoDispose<Set<MemoryWord>>((ref) {
      final memoryState = ref.watch(memoryProvider);
      return memoryState.memoryWords;
    });

    final allWordsAsync = ref.watch(allWordsProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Memory Game!'),
          centerTitle: true,
        ),
        body: allWordsAsync.when(
            data: (data) {
              if (data.isNotEmpty) {
                return Container(
                  color: Colors.green,
                  child: GridContent(memoryWords: data),
                );
              } else {
                return const LoadingScreen();
              }
            },
            error: (e, stack) => Container(
                  color: Colors.red,
                ),
            loading: () => const LoadingScreen()));
  }

  _setUp(
      {required TopicsDataState topicsDataState,
      required MemoryNotifier memoryNotifier}) async {
    Set<WordData> allWords =
        await allWordsToList(topicsDataState: topicsDataState);
    allWords = shuffleAllWords(allWordsSet: allWords, limit: 18);
    allWords = await getWordsURLs(words: allWords);
    Set<MemoryWord> memoryWords = {};

    for (int i = 0; i < 18; i++) {
      memoryWords.add(
        MemoryWord(
          index: i,
          word: allWords.elementAt(i),
          isAnswered: false,
        ),
      );
      memoryWords.add(
        MemoryWord(
          index: i + 18,
          word: allWords.elementAt(i),
          showChinese: true,
          isAnswered: false,
        ),
      );
    }

    memoryNotifier.addMemoryWords(memoryWords: memoryWords);
  }
}
