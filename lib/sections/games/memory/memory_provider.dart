import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/word_data.dart';
import 'memory_word.dart';

class MemoryState {
  final Set<WordData> allSelectedWords;
  final Map<int, MemoryWord> memoryWords;
  final bool flipBackTiles;

  MemoryState({
    required this.allSelectedWords,
    required this.memoryWords,
    required this.flipBackTiles,
  });

  MemoryState copyWith({
    Set<WordData>? allSelectedWords,
    Map<int, MemoryWord>? memoryWords,
    bool? flipBackTiles,
  }) {
    return MemoryState(
      allSelectedWords: allSelectedWords ?? this.allSelectedWords,
      memoryWords: memoryWords ?? this.memoryWords,
      flipBackTiles: flipBackTiles ?? this.flipBackTiles,
    );
  }
}

class MemoryNotifier extends StateNotifier<MemoryState> {
  MemoryNotifier(MemoryState state) : super(state);

  addMemoryWords({required Map<int, MemoryWord> memoryWords}) {
    state = state.copyWith(memoryWords: memoryWords);
  }

  tileTapped({required MapEntry<int, MemoryWord> memoryWord}) {
    int numberTapped = state.memoryWords.entries
        .where((element) => element.value.isTapped)
        .length;
    if (numberTapped < 2) {
      var updatedWords = state.memoryWords;
      updatedWords.update(memoryWord.key,
          (value) => MemoryWord(
              word: memoryWord.value.word,
              isTapped: true,
              showChinese: memoryWord.value.showChinese));
      state = state.copyWith(memoryWords: updatedWords);
    }
  }

  tileFlippedHalf({required MapEntry<int, MemoryWord> memoryWord}) {
    state.memoryWords;
    var updatedWords = state.memoryWords;
    updatedWords.update(
      memoryWord.key,
      (value) => MemoryWord(
        word: memoryWord.value.word,
        isHalfFlipped: true,
        showChinese: memoryWord.value.showChinese
      ),
    );
    state = state.copyWith(memoryWords: updatedWords);
  }
}

final memoryProvider = StateNotifierProvider<MemoryNotifier, MemoryState>(
  (ref) => MemoryNotifier(
    MemoryState(
      allSelectedWords: {},
      memoryWords: {},
      flipBackTiles: false,
    ),
  ),
);
