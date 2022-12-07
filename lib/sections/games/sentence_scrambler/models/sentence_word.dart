import 'package:flutter/material.dart';
import 'package:studychinesetoday/models/word_data.dart';

class SentenceWord {
  final WordData wordData;
  int correctPosition;
  int? placedPosition;
  Offset? originalOffset;
  Offset? placedOffset;

  SentenceWord({
    required this.wordData,
    required this.correctPosition,
    this.placedPosition,
    this.originalOffset,
    this.placedOffset,
  });
}
