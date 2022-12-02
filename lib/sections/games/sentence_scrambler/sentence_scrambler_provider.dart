import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/word_data.dart';
import 'letter_block.dart';

class SentenceScramblerState {
  final Offset originalPosition;
  final Offset droppedPosition;
  final bool animate;
  final LetterBlock letterBlock;
  final bool isAnimatingBackToPosition;

  SentenceScramblerState({
    required this.originalPosition,
    required this.droppedPosition,
    required this.animate,
    required this.letterBlock,
    required this.isAnimatingBackToPosition,
  });

  SentenceScramblerState copyWith({
    Offset? originalPosition,
    Offset? droppedPosition,
    bool? animate,
    LetterBlock? letterBlock,
    bool? isAnimatingBackToPosition,
  }) {
    return SentenceScramblerState(
      originalPosition: originalPosition ?? this.originalPosition,
      droppedPosition: droppedPosition ?? this.droppedPosition,
      animate: animate ?? this.animate,
      letterBlock: letterBlock ?? this.letterBlock,
      isAnimatingBackToPosition:
          isAnimatingBackToPosition ?? this.isAnimatingBackToPosition,
    );
  }
}

class SentenceScramblerNotifier extends StateNotifier<SentenceScramblerState> {
  SentenceScramblerNotifier(SentenceScramblerState state) : super(state);

  animateBackToPosition({
    required Offset originalPosition,
    required Offset droppedPosition,
    required bool animate,
    required LetterBlock letterBlock,
  }) {
    state = state.copyWith(
        originalPosition: originalPosition,
        droppedPosition: droppedPosition,
        animate: animate,
        letterBlock: letterBlock,
        isAnimatingBackToPosition: true);
  }

  setAnimationStatus({required bool isAnimatingBack}) {
    state = state.copyWith(isAnimatingBackToPosition: isAnimatingBack);
  }
}

final sentenceScramblerProvider =
    StateNotifierProvider<SentenceScramblerNotifier, SentenceScramblerState>(
  (ref) => SentenceScramblerNotifier(
    SentenceScramblerState(
      originalPosition: const Offset(0, 0),
      droppedPosition: const Offset(0, 0),
      animate: false,
      letterBlock: const LetterBlock(
          wordData: WordData(english: '', character: '', pinyin: ''),
          index: 999),
      isAnimatingBackToPosition: false,
    ),
  ),
);
