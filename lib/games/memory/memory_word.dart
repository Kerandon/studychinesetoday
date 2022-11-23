import 'package:equatable/equatable.dart';

import '../../models/word_data.dart';

class MemoryWord extends Equatable {
  final int index;
  final WordData word;
  final bool showChinese;
  final bool isAnswered;

  const MemoryWord(
      {required this.index,
        required this.word,
        required this.isAnswered,
        this.showChinese = false});

  @override
  List<Object> get props => [index];
}