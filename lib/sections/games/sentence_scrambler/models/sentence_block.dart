import 'package:flutter/material.dart';
import 'package:studychinesetoday/models/word_data.dart';

class SentenceBlock {
  final WordData wordData;
  int correctPosition;
  int? placedPosition;
  Offset? originalOffset;
  Offset? placedOffset;
  bool hideChildUI;

  SentenceBlock({
    required this.wordData,
    required this.correctPosition,
    this.placedPosition,
    this.originalOffset,
    this.placedOffset,
    this.hideChildUI = false,
  });
}
