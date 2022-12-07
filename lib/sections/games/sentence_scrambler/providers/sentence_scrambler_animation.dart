// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';
//
// import '../../../../models/word_data.dart';
// import '../components/letter_block.dart';
//
// class SentenceAnimationState {
//   final Offset originalPosition;
//   final Offset droppedPosition;
//   final bool animate;
//   final LetterBlock letterBlock;
//   final bool isAnimatingBackToPosition;
//
//   SentenceAnimationState({
//     required this.originalPosition,
//     required this.droppedPosition,
//     required this.animate,
//     required this.letterBlock,
//     required this.isAnimatingBackToPosition,
//   });
//
//   SentenceAnimationState copyWith({
//     Offset? originalPosition,
//     Offset? droppedPosition,
//     bool? animate,
//     LetterBlock? letterBlock,
//     bool? isAnimatingBackToPosition,
//   }) {
//     return SentenceAnimationState(
//       originalPosition: originalPosition ?? this.originalPosition,
//       droppedPosition: droppedPosition ?? this.droppedPosition,
//       animate: animate ?? this.animate,
//       letterBlock: letterBlock ?? this.letterBlock,
//       isAnimatingBackToPosition:
//           isAnimatingBackToPosition ?? this.isAnimatingBackToPosition,
//     );
//   }
// }
//
// class SentenceAnimationNotifier extends StateNotifier<SentenceAnimationState> {
//   SentenceAnimationNotifier(SentenceAnimationState state) : super(state);
//
//   animateBackToPosition({
//     required Offset originalPosition,
//     required Offset droppedPosition,
//     required bool animate,
//     required LetterBlock letterBlock,
//   }) {
//     state = state.copyWith(
//         originalPosition: originalPosition,
//         droppedPosition: droppedPosition,
//         animate: animate,
//         letterBlock: letterBlock,
//         isAnimatingBackToPosition: true);
//   }
//
//   setAnimationStatus({required bool isAnimatingBack}) {
//     state = state.copyWith(isAnimatingBackToPosition: isAnimatingBack);
//   }
// }
//
// final sentenceAnimationProvider =
//     StateNotifierProvider<SentenceAnimationNotifier, SentenceAnimationState>(
//   (ref) => SentenceAnimationNotifier(
//     SentenceAnimationState(
//       originalPosition: const Offset(0, 0),
//       droppedPosition: const Offset(0, 0),
//       animate: false,
//       letterBlock: LetterBlock(
//         sentenceWord: SentenceWord(correctPosition: 1, wordData: WordData(english: "", character: "", pinyin: "")),
//         index: 0,
//       ),
//       isAnimatingBackToPosition: false,
//     ),
//   ),
// );
