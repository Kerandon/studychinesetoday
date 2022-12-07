import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/utils/enums/answer_state.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';

class SentenceScramblerState {
  final List<SentenceWord> currentSentence;
  final bool allPlaced;
  final AnswerState answerState;
  final bool recallWords;

  SentenceScramblerState({
    required this.currentSentence,
    required this.allPlaced,
    required this.answerState,
    required this.recallWords,
  });

  SentenceScramblerState copyWith({
    List<SentenceWord>? currentSentence,
    bool? allPlaced,
    AnswerState? answerState,
    bool? recallWords,
  }) {
    return SentenceScramblerState(
      currentSentence: currentSentence ?? this.currentSentence,
      allPlaced: allPlaced ?? this.allPlaced,
      answerState: answerState ?? this.answerState,
      recallWords: recallWords ?? this.recallWords,
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

  void blockDropped({required SentenceWord sentenceWord, required Offset droppedOffset}){
    List<SentenceWord> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == sentenceWord.correctPosition) {
        w.placedOffset = droppedOffset;
      }
    }



    state = state.copyWith(currentSentence: currentSentence);

    for(var w in state.currentSentence){
      print('blocks dropped ${w.wordData.english} and original pos ${w.originalOffset} and dropped pos ${w.placedOffset}');
    }

  }

  void wordPlaced(
      {required SentenceWord sentenceWord}) {

    List<SentenceWord> currentSentence = state.currentSentence;

    for (var w in currentSentence) {
      if (w.correctPosition == sentenceWord.correctPosition) {
            w.placedPosition = sentenceWord.placedPosition;
            w.placedOffset = sentenceWord.placedOffset;
      }
    }

    final allPlaced =
        currentSentence.every((element) => element.placedPosition != null);

    state =
        state.copyWith(currentSentence: currentSentence, allPlaced: allPlaced);

  }

  void checkAnswer() {
    final correct = state.currentSentence
        .every((element) => element.placedPosition == element.correctPosition);
    state = state.copyWith(
        answerState: correct ? AnswerState.correct : AnswerState.incorrect);
  }

  void recallWords({required bool recall}) {
    state = state.copyWith(recallWords: recall);
  }

  recallAnimationCompleted({required List<SentenceWord> words}){
    List<SentenceWord> currentSentence = state.currentSentence;

    for(var c in currentSentence){
      for(var w in words){
        if(c.correctPosition == w.correctPosition){

          c.placedPosition = null;
          w.placedOffset = null;

        }
      }
    }

    // for(var w in currentSentence){
    //   if(w.correctPosition == words.where((element) => element.correctPosition))){
    //     w.placedPosition = null;
    //     w.placedOffset = null;
    //   }
    // }
    state = state.copyWith(currentSentence: currentSentence);
  }

}

final sentenceScramblerProvider =
    StateNotifierProvider<SentenceScramblerNotifier, SentenceScramblerState>(
  (ref) => SentenceScramblerNotifier(
    SentenceScramblerState(
      currentSentence: [],
      allPlaced: false,
      answerState: AnswerState.notAnswered,
      recallWords: false,
    ),
  ),
);
