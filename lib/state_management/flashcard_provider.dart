import 'package:riverpod/riverpod.dart';
import 'package:studychinesetoday/utils/enums/session_type.dart';
import '../models/topic.dart';
import '../utils/enums/card_stages.dart';

class FlashcardManager {
  final int currentIndex;
  final int totalNumberOfCards;
  final Map<String, String> urls;
  final Map<int, bool> flipCard;
  final List<Map<int, bool>> hasHalfFlipped;
  final List<Topic> unansweredCards;
  final List<Topic> correctCards;
  final List<Topic> incorrectCards;
  final CardStage cardStage;
  final bool roundCompleted;
  final int roundIndex;
  final bool sessionCompleted;
  final int maxNumberOfCards;

  FlashcardManager({
    required this.currentIndex,
    required this.totalNumberOfCards,
    required this.urls,
    required this.flipCard,
    required this.hasHalfFlipped,
    required this.cardStage,
    required this.correctCards,
    required this.unansweredCards,
    required this.incorrectCards,
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
    List<Topic>? unansweredCards,
    List<Topic>? correctCards,
    List<Topic>? incorrectCards,
    bool? roundCompleted,
    int? roundIndex,
    bool? sessionCompleted,
    int? maxNumberOfCards,
  }) {
    return FlashcardManager(
      currentIndex: currentIndex ?? this.currentIndex,
      totalNumberOfCards: totalCards ?? this.totalNumberOfCards,
      urls: urls ?? this.urls,
      flipCard: flipCard ?? this.flipCard,
      hasHalfFlipped: hasHalfFlipped ?? this.hasHalfFlipped,
      cardStage: cardStage ?? this.cardStage,
      unansweredCards: unansweredCards ?? this.unansweredCards,
      correctCards: correctCards ?? this.correctCards,
      incorrectCards: incorrectCards ?? this.incorrectCards,
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

  void setUnansweredWords({required List<Topic> words}) {
    state = state.copyWith(unansweredCards: words);
  }

  void setCurrentIndex({required int total}) {
    state = state.copyWith(currentIndex: total);
    if (state.currentIndex + 1 == 0) {
      state = state.copyWith(
          roundCompleted: true, roundIndex: state.roundIndex + 1);
      if (state.incorrectCards.isEmpty) {
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

  void addToCorrectCards({required Topic card}) {
    state = state.copyWith(correctCards: [...state.correctCards, card]);
  }

  void addToIncorrectCards({required Topic card}) {
    state = state.copyWith(incorrectCards: [...state.incorrectCards, card]);
  }

  void setRoundCompleted({required bool completed}) {
    state = state.copyWith(roundCompleted: completed);
  }

  void setWords(
      {required SessionType sessionType, List<Topic> cards = const []}) {
    state = state.copyWith(unansweredCards: []);
    if (sessionType == SessionType.newSession) {
      if (cards.isEmpty) {}
      state = state.copyWith(unansweredCards: cards);
    } else if (sessionType == SessionType.repeatIncorrect) {
      state = state.copyWith(unansweredCards: [...state.incorrectCards]);
    } else if (sessionType == SessionType.repeatIncorrect) {
      state = state.copyWith(
          unansweredCards: [...state.incorrectCards, ...state.correctCards]);
    }
  }

  void setMaxNumberOfCards({required int number}){
    state = state.copyWith(maxNumberOfCards: number);
    print('max number of cards is ${state.maxNumberOfCards}');
  }

  void reset({required bool newSession}) {
    state = state.copyWith(
      urls: newSession ? {} : {...state.urls},
      currentIndex: 0,
      totalCards: 0,
      flipCard: {0: false},
      hasHalfFlipped: [],
      cardStage: CardStage.flip,
      unansweredCards: newSession ? [] : [...state.unansweredCards],
      correctCards: [],
      incorrectCards: [],
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
      totalNumberOfCards: 0,
      flipCard: {0: false},
      hasHalfFlipped: [],
      cardStage: CardStage.flip,
      unansweredCards: [],
      correctCards: [],
      incorrectCards: [],
      roundCompleted: false,
      roundIndex: 0,
      sessionCompleted: false,
      maxNumberOfCards: 10,
    ),
  ),
);
