import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/utils/enums/answer_state.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_block.dart';

class SentenceScramblerState {
  final List<SentenceBlock> currentSentence;
  final bool allPlaced;
  final AnswerState answerState;
  final bool recallDroppedWord;
  final bool recallAllWords;
  final bool animateToCorrectPosition;
  final bool newSentence;

  SentenceScramblerState({
    required this.currentSentence,
    required this.allPlaced,
    required this.answerState,
    required this.recallDroppedWord,
    required this.recallAllWords,
    required this.animateToCorrectPosition,
    required this.newSentence,
  });

  SentenceScramblerState copyWith({
    List<SentenceBlock>? currentSentence,
    bool? allPlaced,
    AnswerState? answerState,
    bool? recallDroppedWord,
    bool? recallAllWords,
    bool? animateToCorrectPosition,
    bool? newSentence,
  }) {
    return SentenceScramblerState(
      currentSentence: currentSentence ?? this.currentSentence,
      allPlaced: allPlaced ?? this.allPlaced,
      answerState: answerState ?? this.answerState,
      recallDroppedWord: recallDroppedWord ?? this.recallDroppedWord,
      recallAllWords: recallAllWords ?? this.recallAllWords,
      animateToCorrectPosition:
          animateToCorrectPosition ?? this.animateToCorrectPosition,
      newSentence: newSentence ?? this.newSentence,
    );
  }
}

class SentenceScramblerNotifier extends StateNotifier<SentenceScramblerState> {
  SentenceScramblerNotifier(super.state);

  void setCurrentSentence({required List<SentenceBlock> sentence}) {
    state = state.copyWith(currentSentence: sentence);
  }

  void setBlockOriginalPosition(
      {required SentenceBlock sentenceWord, required Offset offsetPosition}) {
    List<SentenceBlock> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == sentenceWord.correctPosition) {
        w = sentenceWord;
        w.originalOffset = offsetPosition;
      }
    }

    state = state.copyWith(currentSentence: currentSentence);
  }

  void blockDragCanceled(
      {required SentenceBlock sentenceWord, required Offset droppedOffset}) {
    List<SentenceBlock> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == sentenceWord.correctPosition) {
        w.placedOffset = droppedOffset;
        w.placedPosition = null;
        w.hideChildUI = true;
      }
    }
    state = state.copyWith(currentSentence: currentSentence);
  }

  void wordAccepted({required SentenceBlock sentenceWord}) {
    List<SentenceBlock> currentSentence = state.currentSentence;

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

  recallAnimationCompleted({required List<SentenceBlock> words}) {
    List<SentenceBlock> currentSentence = state.currentSentence;
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

  void showCorrectSentence({required Size screenSize}) {
    List<SentenceBlock> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == w.placedPosition) {
        w.originalOffset = w.placedOffset;
      } else {
        SentenceBlock word = currentSentence.firstWhere(
            (element) => w.correctPosition == element.placedPosition);
        w.originalOffset = word.placedOffset;
      }
    }

    for (var w in currentSentence) {
      w.originalOffset = Offset(w.originalOffset!.dx,
          w.originalOffset!.dy + (screenSize.height * 0.20));
    }

    state = state.copyWith(animateToCorrectPosition: true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state = state.copyWith(
          currentSentence: currentSentence, animateToCorrectPosition: true);
    });
  }

  void generateNewSentence({required bool generate}) {
      state = state.copyWith(newSentence: generate);
  }

  void reset(){
    state = state.copyWith(
        currentSentence: [],
        allPlaced: false,
        answerState: AnswerState.notAnswered,
        recallDroppedWord: false,
        recallAllWords: false,
        animateToCorrectPosition: false,
        newSentence: false,


    );

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
      newSentence: false,
    ),
  ),
);
