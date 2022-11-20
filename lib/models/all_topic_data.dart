import 'package:equatable/equatable.dart';
import 'package:studychinesetoday/models/word.dart';


class Topic extends Equatable {

  final String english;
  final String character;
  final String pinyin;
  final String? url;
  final List<Word> words;

  const Topic({required this.english, required this.character, required this.pinyin, required this.words, this.url});

  @override
  List<Object> get props => [english];


}