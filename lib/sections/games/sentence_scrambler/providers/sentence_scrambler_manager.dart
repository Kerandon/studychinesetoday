import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/utils/enums/answer_state.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';

class SentenceScramblerState {
  final List<SentenceWord> currentSentence;
  final bool allPlaced;
  final AnswerState answerState;
  final bool recallDroppedWord;
  final bool recallAllWords;
  final bool animateToCorrectPosition;

  SentenceScramblerState({
    required this.currentSentence,
    required this.allPlaced,
    required this.answerState,
    required this.recallDroppedWord,
    required this.recallAllWords,
    required this.animateToCorrectPosition,
  });

  SentenceScramblerState copyWith({
    List<SentenceWord>? currentSentence,
    bool? allPlaced,
    AnswerState? answerState,
    bool? recallDroppedWord,
    bool? recallAllWords,
    bool? animateToCorrectPosition,
  }) {
    return SentenceScramblerState(
      currentSentence: currentSentence ?? this.currentSentence,
      allPlaced: allPlaced ?? this.allPlaced,
      answerState: answerState ?? this.answerState,
      recallDroppedWord: recallDroppedWord ?? this.recallDroppedWord,
      recallAllWords: recallAllWords ?? this.recallAllWords,
      animateToCorrectPosition: animateToCorrectPosition ?? this.animateToCorrectPosition,
    );
  }
}

class SentenceScramblerNotifier extends StateNotifier<SentenceScramblerState> {
  SentenceScramblerNotifier(super.state);

  void setCurrentSentence({required List<SentenceWord> sentence}) {
    state = state.copyWith(currentSentence: sentence);
  }

  void setBlockOriginalPosition(
      {required SentenceWord sentenceWord, required Offset offsetPosition}) {
    List<SentenceWord> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == sentenceWord.correctPosition) {
        w = sentenceWord;
        w.originalOffset = offsetPosition;
      }
    }

    state = state.copyWith(currentSentence: currentSentence);
  }

  void blockDragCanceled(
      {required SentenceWord sentenceWord, required Offset droppedOffset}) {
    List<SentenceWord> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == sentenceWord.correctPosition) {
        w.placedOffset = droppedOffset;
        w.placedPosition = null;
        w.hideChildUI = true;
      }
    }
    state = state.copyWith(currentSentence: currentSentence);
  }

  void wordAccepted({required SentenceWord sentenceWord}) {
    List<SentenceWord> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == sentenceWord.correctPosition) {
        w.placedPosition = sentenceWord.placedPosition;
        w.placedOffset = sentenceWord.placedOffset;
      }
    }

    final allAccepted =
        currentSentence.every((element) => element.placedPosition != null);

    state = state.copyWith(
        currentSentence: currentSentence, allPlaced: allAccepted);
  }

  void checkAnswer() {
    final isCorrect = state.currentSentence
        .every((element) => element.placedPosition == element.correctPosition);
    state = state.copyWith(
        answerState: isCorrect ? AnswerState.correct : AnswerState.incorrect);
  }

  void recallDroppedWord({required bool recall}) {
    state = state.copyWith(recallDroppedWord: recall);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        state = state.copyWith(recallDroppedWord: recall);
      },
    );
  }

  void recallAllWords({required bool recall}) {
    state = state.copyWith(recallAllWords: recall);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        state = state.copyWith(recallAllWords: recall);
      },
    );
  }

  recallAnimationCompleted({required List<SentenceWord> words}) {




    List<SentenceWord> currentSentence = state.currentSentence;
    for (var c in currentSentence) {
      c.hideChildUI = false;
      for (var w in words) {
        if (c.correctPosition == w.correctPosition) {
          c.placedPosition = null;
          c.placedOffset = null;
        }
      }
    }
    state = state.copyWith(currentSentence: currentSentence);
  }

  void showCorrectSentence({required bool runAnimation}){

    if(runAnimation) {
      List<SentenceWord> currentSentence = state.currentSentence;

      for (var w in currentSentence) {
        if (w.correctPosition == w.placedPosition) {
          w.originalOffset = w.placedOffset;
        } else {
          for (var word in currentSentence) {
            if (w.placedPosition == word.correctPosition) {
              w.originalOffset = word.placedOffset;
            }
          }
        }
      }

      state = state.copyWith(
          currentSentence: currentSentence,
          animateToCorrectPosition: true);
    }
  }

}

final sentenceScramblerProvider =
    StateNotifierProvider<SentenceScramblerNotifier, SentenceScramblerState>(
  (ref) => SentenceScramblerNotifier(
    SentenceScramblerState(
      currentSentence: [],
      allPlaced: false,
      answerState: AnswerState.notAnswered,
      recallDroppedWord: false,
      recallAllWords: false,
      animateToCorrectPosition: false,
    ),
  ),
);
