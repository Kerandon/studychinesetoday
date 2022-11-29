import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/word_data.dart';
import 'memory_word.dart';

class MemoryState {
  final Set<WordData> allSelectedWords;
  final Map<int, MemoryModel> memoryWords;
  final Map<int, MemoryModel> tappedWords;
  final Set<int> answeredCorrectly;
  final bool canFlip;
  final bool reverseFlip;
  final bool ignoreTaps;
  final int numberCardsFullFlipped;

  MemoryState({
    required this.allSelectedWords,
    required this.memoryWords,
    required this.tappedWords,
    required this.answeredCorrectly,
    required this.canFlip,
    required this.reverseFlip,
    required this.ignoreTaps,
    required this.numberCardsFullFlipped,
  });

  MemoryState copyWith({
    Set<WordData>? allSelectedWords,
    Map<int, MemoryModel>? memoryWords,
    Map<int, MemoryModel>? tappedWords,
    Set<int>? answeredCorrectly,
    bool? canFlip,
    bool? reverseFlip,
    bool? ignoreTaps,
    int? numberCardsFullFlipped,
  }) {
    return MemoryState(
      allSelectedWords: allSelectedWords ?? this.allSelectedWords,
      memoryWords: memoryWords ?? this.memoryWords,
      tappedWords: tappedWords ?? this.tappedWords,
      answeredCorrectly: answeredCorrectly ?? this.answeredCorrectly,
      canFlip: canFlip ?? this.canFlip,
      reverseFlip: reverseFlip ?? this.reverseFlip,
      ignoreTaps: ignoreTaps ?? this.ignoreTaps,
      numberCardsFullFlipped:
          numberCardsFullFlipped ?? this.numberCardsFullFlipped,
    );
  }
}

class MemoryNotifier extends StateNotifier<MemoryState> {
  MemoryNotifier(MemoryState state) : super(state);

  addMemoryWords({required Map<int, MemoryModel> memoryWords}) {
    state = state.copyWith(memoryWords: memoryWords);
  }

  tileTapped({required MapEntry<int, MemoryModel> memoryWord}) {
    if (state.tappedWords.entries.length < 2) {
      state = state.copyWith(
          tappedWords: {...state.tappedWords, memoryWord.key: memoryWord.value},
          canFlip: true);
    } else {
      state = state.copyWith(canFlip: false, ignoreTaps: true);
    }
  }

  onHalfFlip(
      {required MapEntry<int, MemoryModel> memoryWord,
      required bool isForward}) {
    var updatedWords = state.memoryWords;
    updatedWords.update(
      memoryWord.key,
      (value) => MemoryModel(
        word: memoryWord.value.word,
        showChinese: memoryWord.value.showChinese,
        flipCard: isForward,
      ),
    );
    state = state.copyWith(memoryWords: updatedWords);
  }

  onFullFlip({required MapEntry<int, MemoryModel> memoryWord}) {
    if (state.tappedWords.entries.length == 2) {
      if (state.tappedWords.entries.elementAt(0).value.word.english ==
          state.tappedWords.entries.elementAt(1).value.word.english) {
        state = state.copyWith(answeredCorrectly: {
          ...state.answeredCorrectly,
          ...state.tappedWords.keys
        }, tappedWords: {}, ignoreTaps: false);
      } else {
        state =
            state.copyWith(reverseFlip: true, canFlip: true, ignoreTaps: true);
      }
    } else {
      state = state.copyWith(ignoreTaps: false);
    }
  }

  onReverseFlip() {
    var updatedWords = state.memoryWords;
    for (var w in updatedWords.entries) {
      if (!state.answeredCorrectly.contains(w.key)) {
        updatedWords.update(
          w.key,
          (value) => MemoryModel(
            word: w.value.word,
            showChinese: w.value.showChinese,
            flipCard: false,
          ),
        );
      }
    }

    state = state.copyWith(
        memoryWords: updatedWords,
        canFlip: true,
        reverseFlip: false,
        tappedWords: {},
        ignoreTaps: false);
  }
}

final memoryProvider = StateNotifierProvider<MemoryNotifier, MemoryState>(
  (ref) => MemoryNotifier(
    MemoryState(
      allSelectedWords: {},
      memoryWords: {},
      tappedWords: {},
      answeredCorrectly: {},
      canFlip: false,
      reverseFlip: false,
      ignoreTaps: false,
      numberCardsFullFlipped: 0,
    ),
  ),
);
