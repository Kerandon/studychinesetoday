

import '../../../models/word_data.dart';

class MemoryWord {
  final WordData word;
  final bool showChinese;
  final bool isTapped;
  final bool isFullyFlippedAround;
  final bool isHalfFlipped;
  final bool isAnswered;

  const MemoryWord({
    required this.word,
    this.isTapped = false,
    this.isFullyFlippedAround = false,
    this.isHalfFlipped = false,
    this.showChinese = false,
    this.isAnswered = false,
  });

}
