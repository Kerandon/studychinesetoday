import '../../../models/word_data.dart';

class MemoryModel {
  final WordData word;
  final bool showChinese;
  final bool isTapped;
  final bool isHalfFlipped;
  final bool isFullyFlipped;
  final bool isAnswered;
  final bool reverseFlip;

  const MemoryModel({
    required this.word,
    this.showChinese = false,
    this.isTapped = false,
    this.isHalfFlipped = false,
    this.isFullyFlipped = false,
    this.isAnswered = false,
    this.reverseFlip = false,
  });
}
