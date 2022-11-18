import 'package:riverpod/riverpod.dart';
import 'package:studychinesetoday/utils/enums/session_type.dart';
import '../models/word.dart';
import '../utils/enums/card_stages.dart';

class FlashcardManager {
  final int currentIndex;
  final int totalCards;
  final Map<String, String> urls;
  final Map<int, bool> flipCard;
  final List<Map<int, bool>> hasHalfFlipped;
  final List<Word> unansweredWords;
  final List<Word> correctWords;
  final List<Word> incorrectWords;
  final CardStage cardStage;
  final bool roundCompleted;
  final int roundIndex;
  final bool sessionCompleted;
  final int maxNumberOfCards;

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
    required this.maxNumberOfCards,
  });

  FlashcardManager copyWith({
    int? currentIndex,
    int? totalCards,
    Map<String, String>? urls,
    Map<int, bool>? flipCard,
    List<Map<int, bool>>? hasHalfFlipped,
    CardStage? cardStage,
    List<Word>? unansweredWords,
    List<Word>? correctWords,
    List<Word>? incorrectWords,
    bool? roundCompleted,
    int? roundIndex,
    bool? sessionCompleted,
    int? maxNumberOfCards,
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
      maxNumberOfCards: maxNumberOfCards ?? this.maxNumberOfCards,
    );
  }
}

class FlashcardNotifier extends StateNotifier<FlashcardManager> {
  FlashcardNotifier(FlashcardManager state) : super(state);

  void setURLs({required Map<String, String> urls}){
    state = state.copyWith(urls: urls);
  }

  void setUnansweredWords({required List<Word> words}) {
    words.shuffle();
    state = state.copyWith(unansweredWords: words);
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

  void totalCards({required int total}) {
    state = state.copyWith(totalCards: total);
  }

  void setFlip({required Map<int, bool> flip}) {
    state = state.copyWith(flipCard: flip);
  }

  void setHasHalfFlipped({required Map<int, bool> halfFlipped}) {
    state =
        state.copyWith(hasHalfFlipped: [...state.hasHalfFlipped, halfFlipped]);
  }

  void setCardState({required CardStage stage}) {
    state = state.copyWith(cardStage: stage);
  }

  void addToCorrectCards({required Word card}) {
    state = state.copyWith(correctWords: [...state.correctWords, card]);
  }

  void addToIncorrectCards({required Word card}) {
    state = state.copyWith(incorrectWords: [...state.incorrectWords, card]);
  }

  void setRoundCompleted({required bool completed}) {
    state = state.copyWith(roundCompleted: completed);
  }

  void setWords(
      {required SessionType sessionType, List<Word> cards = const []}) {
    state = state.copyWith(unansweredWords: []);
    if (sessionType == SessionType.newSession) {
      if (cards.isEmpty) {}
      state = state.copyWith(unansweredWords: cards);
    } else if (sessionType == SessionType.repeatIncorrect) {
      state = state.copyWith(unansweredWords: [...state.incorrectWords]);
    } else if (sessionType == SessionType.repeatIncorrect) {
      state = state.copyWith(
          unansweredWords: [...state.incorrectWords, ...state.correctWords]);
    }
  }

  void setMaxNumberOfCards({required int number}){
    state = state.copyWith(maxNumberOfCards: number);
  }

  void reset({required bool newSession}) {
    state = state.copyWith(
      urls: newSession ? {} : {...state.urls},
      currentIndex: 0,
      totalCards: 0,
      flipCard: {0: false},
      hasHalfFlipped: [],
      cardStage: CardStage.flip,
      unansweredWords: newSession ? [] : [...state.unansweredWords],
      correctWords: [],
      incorrectWords: [],
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
      hasHalfFlipped: [],
      cardStage: CardStage.flip,
      unansweredWords: [],
      correctWords: [],
      incorrectWords: [],
      roundCompleted: false,
      roundIndex: 0,
      sessionCompleted: false,
      maxNumberOfCards: 3,
    ),
  ),
);
