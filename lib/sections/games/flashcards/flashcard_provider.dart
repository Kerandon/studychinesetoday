import 'package:riverpod/riverpod.dart';
import 'package:studychinesetoday/utils/enums/session_type.dart';

import '../../../../models/word_data.dart';
import '../../../../utils/enums/card_stages.dart';

class FlashcardManager {
  final int currentIndex;
  final int totalCards;
  final Map<String, String> urls;
  final Map<int, bool> flipCard;
  final Set<Map<int, bool>> hasHalfFlipped;
  final Set<WordData> unansweredWords;
  final Set<WordData> correctWords;
  final Set<WordData> incorrectWords;
  final CardStage cardStage;
  final bool roundCompleted;
  final int roundIndex;
  final bool sessionCompleted;
  final int preferredNumberOfCards;

  FlashcardManager({
    required this.currentIndex,
    required this.totalCards,
    required this.urls,
    required this.flipCard,
    required this.hasHalfFlipped,
    required this.cardStage,
    required this.correctWords,
    required this.unansweredWords,
    required this.incorrectWords,
    required this.roundCompleted,
    required this.roundIndex,
    required this.sessionCompleted,
    required this.preferredNumberOfCards,
  });

  FlashcardManager copyWith({
    int? currentIndex,
    int? totalCards,
    Map<String, String>? urls,
    Map<int, bool>? flipCard,
    Set<Map<int, bool>>? hasHalfFlipped,
    CardStage? cardStage,
    Set<WordData>? unansweredWords,
    Set<WordData>? correctWords,
    Set<WordData>? incorrectWords,
    bool? roundCompleted,
    int? roundIndex,
    bool? sessionCompleted,
    int? preferredNumberOfCards,
  }) {
    return FlashcardManager(
      currentIndex: currentIndex ?? this.currentIndex,
      totalCards: totalCards ?? this.totalCards,
      urls: urls ?? this.urls,
      flipCard: flipCard ?? this.flipCard,
      hasHalfFlipped: hasHalfFlipped ?? this.hasHalfFlipped,
      cardStage: cardStage ?? this.cardStage,
      unansweredWords: unansweredWords ?? this.unansweredWords,
      correctWords: correctWords ?? this.correctWords,
      incorrectWords: incorrectWords ?? this.incorrectWords,
      roundCompleted: roundCompleted ?? this.roundCompleted,
      roundIndex: roundIndex ?? this.roundIndex,
      sessionCompleted: sessionCompleted ?? this.sessionCompleted,
      preferredNumberOfCards:
          preferredNumberOfCards ?? this.preferredNumberOfCards,
    );
  }
}

class FlashcardNotifier extends StateNotifier<FlashcardManager> {
  FlashcardNotifier(FlashcardManager state) : super(state);

  void setURLs({required Map<String, String> urls}) {
    state = state.copyWith(urls: urls);
  }

  void setUnansweredWords({required Set<WordData> words}) {
    var shuffleWords = words.toList();
    shuffleWords = shuffleWords..shuffle();

    state = state.copyWith(unansweredWords: shuffleWords.toSet());
  }

  void setCurrentIndex({required int total}) {
    state = state.copyWith(currentIndex: total);
    if (state.currentIndex + 1 == 0) {
      state = state.copyWith(
          roundCompleted: true, roundIndex: state.roundIndex + 1);
      if (state.incorrectWords.isEmpty) {
        state = state.copyWith(sessionCompleted: true);
      }
    }
  }

  void setTotalCards({required int total}) {
    state = state.copyWith(totalCards: total, currentIndex: total);
  }

  void decreaseCurrentIndex() {
    state = state.copyWith(currentIndex: state.currentIndex - 1);
  }

  void setFlip({required Map<int, bool> flip}) {
    state = state.copyWith(flipCard: flip);
  }

  void setHasHalfFlipped({required Map<int, bool> halfFlipped}) {
    state =
        state.copyWith(hasHalfFlipped: {...state.hasHalfFlipped, halfFlipped});
  }

  void setCardState({required CardStage stage}) {
    state = state.copyWith(cardStage: stage);
  }

  void addToCorrectCards({required WordData card}) {
    state = state.copyWith(correctWords: {...state.correctWords, card});
  }

  void addToIncorrectCards({required WordData card}) {
    state = state.copyWith(incorrectWords: {...state.incorrectWords, card});
  }

  void setRoundCompleted({required bool completed}) {
    state = state.copyWith(roundCompleted: completed);
  }

  void setWords(
      {required SessionType sessionType, Set<WordData> cards = const {}}) {
    state = state.copyWith(unansweredWords: {});
    if (sessionType == SessionType.newSession) {
      if (cards.isEmpty) {}
      state = state.copyWith(unansweredWords: cards);
    } else if (sessionType == SessionType.repeatIncorrect) {
      state = state.copyWith(unansweredWords: {...state.incorrectWords});
    } else if (sessionType == SessionType.repeatIncorrect) {
      state = state.copyWith(
          unansweredWords: {...state.incorrectWords, ...state.correctWords});
    }
  }

  void setPreferredNumberOfCards({required int number}) {
    if (number > 0) {
      state = state.copyWith(preferredNumberOfCards: number);
    }
  }

  void reset({required bool newSession}) {
    state = state.copyWith(
      urls: newSession ? {} : {...state.urls},
      currentIndex: 0,
      totalCards: 0,
      flipCard: {0: false},
      hasHalfFlipped: {},
      cardStage: CardStage.flip,
      unansweredWords: newSession ? {} : {...state.unansweredWords},
      correctWords: {},
      incorrectWords: {},
      roundCompleted: false,
      roundIndex: newSession ? 0 : state.roundIndex,
      sessionCompleted: false,
    );
  }
}

final flashcardProvider =
    StateNotifierProvider<FlashcardNotifier, FlashcardManager>(
  (ref) => FlashcardNotifier(
    FlashcardManager(
      urls: {},
      currentIndex: 0,
      totalCards: 0,
      flipCard: {0: false},
      hasHalfFlipped: {},
      cardStage: CardStage.flip,
      unansweredWords: {},
      correctWords: {},
      incorrectWords: {},
      roundCompleted: false,
      roundIndex: 0,
      sessionCompleted: false,
      preferredNumberOfCards: 10,
    ),
  ),
);
