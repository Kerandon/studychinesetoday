import '../../../models/word_data.dart';

class MemoryModel {
  final WordData word;
  final bool showChinese;
  final bool flipCard;

  const MemoryModel({
    required this.word,
    this.showChinese = false,
    this.flipCard = false,
  });
}
