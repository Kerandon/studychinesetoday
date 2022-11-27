import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/word_data.dart';
import 'memory_word.dart';

class MemoryState {
  final Set<WordData> allSelectedWords;
  final Map<int, MemoryModel> memoryWords;
  final bool flipBackTiles;

  MemoryState({
    required this.allSelectedWords,
    required this.memoryWords,
    required this.flipBackTiles,
  });

  MemoryState copyWith({
    Set<WordData>? allSelectedWords,
    Map<int, MemoryModel>? memoryWords,
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

  addMemoryWords({required Map<int, MemoryModel> memoryWords}) {
    state = state.copyWith(memoryWords: memoryWords);
  }

  tileTapped({required MapEntry<int, MemoryModel> memoryWord}) {
    int numberTapped = state.memoryWords.entries
        .where((element) => element.value.isTapped)
        .length;
    if (numberTapped < 2) {
      var updatedWords = state.memoryWords;
      updatedWords.update(
          memoryWord.key,
          (value) => MemoryModel(
              word: memoryWord.value.word,
              isTapped: true,
              showChinese: memoryWord.value.showChinese));
      state = state.copyWith(memoryWords: updatedWords);
    }
  }

  tileFlippedHalf({required MapEntry<int, MemoryModel> memoryWord}) {
    var updatedWords = state.memoryWords;
    updatedWords.update(
      memoryWord.key,
      (value) => MemoryModel(
          word: memoryWord.value.word,
          isHalfFlipped: true,
          showChinese: memoryWord.value.showChinese),
    );
    state = state.copyWith(memoryWords: updatedWords);
  }

  tileFlippedFull({required MapEntry<int, MemoryModel> memoryWord}) {
    var updatedWords = state.memoryWords;
    updatedWords.update(
        memoryWord.key,
        (value) => MemoryModel(
              word: memoryWord.value.word,
              isHalfFlipped: true,
              isFullyFlipped: true,
              showChinese: memoryWord.value.showChinese,
            ));

    state = state.copyWith(memoryWords: updatedWords);

    final Map<int, MemoryModel> flippedWords = {};

    for (var w in state.memoryWords.entries) {
      if (w.value.isFullyFlipped) {
        flippedWords.addEntries({w});
      }
    }

    if (flippedWords.entries.length % 2 == 0) {

      final isMatched = flippedWords.entries.last.value.word.english ==
          flippedWords.entries
              .elementAt(flippedWords.entries.length - 2)
              .value
              .word
              .english;

        if (isMatched) {
        var updatedWords = state.memoryWords;
        for (var w in updatedWords.entries) {
          updatedWords.update(
              w.key,
              (value) => MemoryModel(
                  word: w.value.word,
                  showChinese: w.value.showChinese,
                  isAnswered: w.value.isAnswered));
        }
        for (int i = flippedWords.length - 2; i < flippedWords.length; i++) {
          updatedWords.update(
              flippedWords.entries.elementAt(i).key,
              (value) => MemoryModel(
                  word: updatedWords.entries.elementAt(i).value.word,
                  showChinese:
                      updatedWords.entries.elementAt(i).value.showChinese,
                  isAnswered: true));
        }
      } else {
        for (var w in flippedWords.entries) {
          updatedWords.update(
            w.key,
            (value) => MemoryModel(
              word: w.value.word,
              isHalfFlipped: true,
              isFullyFlipped: true,
              showChinese: w.value.showChinese,
              reverseFlip: true,
            ),
          );
        }
      }
    }
    state = state.copyWith(memoryWords: updatedWords);
  }

  reverseFlipHalfCompleted({required MapEntry<int, MemoryModel> memoryWord}) {
    Map<int, MemoryModel> updatedWords = state.memoryWords;
    for (var w in updatedWords.entries) {
      if (w.value.reverseFlip) {
        updatedWords.update(
            w.key,
            (value) => MemoryModel(
                word: w.value.word, showChinese: w.value.showChinese));
      }
    }
    state = state.copyWith(memoryWords: updatedWords);
  }

  onFlippedBack({required MapEntry<int, MemoryModel> memoryWord}) {
    var updatedWords = state.memoryWords;

    for (var w in updatedWords.entries) {
      updatedWords.update(
          w.key,
          (value) => MemoryModel(
              word: w.value.word, showChinese: w.value.showChinese));
    }

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
