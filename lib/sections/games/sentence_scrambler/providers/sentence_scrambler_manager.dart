import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';

class SentenceScramblerState {
  final List<SentenceWord> currentSentence;

  SentenceScramblerState({required this.currentSentence});

  SentenceScramblerState copyWith({List<SentenceWord>? currentSentence}) {
    return SentenceScramblerState(
        currentSentence: currentSentence ?? this.currentSentence);
  }
}

class SentenceScramblerNotifier extends StateNotifier<SentenceScramblerState> {
  SentenceScramblerNotifier(super.state);

  setCurrentSentence({required List<SentenceWord> sentence}) {
    state = state.copyWith(currentSentence: sentence);
    for (var w in state.currentSentence) {
      print(w.wordData);
    }
  }

  wordAccepted({required SentenceWord sentenceWord}) {
    List<SentenceWord> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.position == sentenceWord.position) {
        w.isPlaced = true;
      }
    }

    state = state.copyWith(currentSentence: currentSentence);

    for (var w in state.currentSentence) {
      print('${w.wordData} + ${w.isPlaced}');
    }
  }
}

final sentenceScramblerProvider =
    StateNotifierProvider<SentenceScramblerNotifier, SentenceScramblerState>(
  (ref) => SentenceScramblerNotifier(
    SentenceScramblerState(
      currentSentence: [],
    ),
  ),
);
