import 'package:equatable/equatable.dart';
import 'package:studychinesetoday/models/word_data.dart';

class SentenceWord extends Equatable {

  final WordData wordData;
  int position;
  bool isPlaced;

  SentenceWord({required this.wordData, required this.position, required this.isPlaced});

  @override
  List<Object> get props => [position];


}