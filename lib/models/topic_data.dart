import 'package:equatable/equatable.dart';
import 'package:studychinesetoday/models/word_data.dart';

class TopicData extends Equatable {
  final String english;
  final String character;
  final String pinyin;
  final String? url;
  final Set<WordData>? words;

  const TopicData(
      {required this.english,
      required this.character,
      required this.pinyin,
      this.words,
      this.url});

  @override
  List<Object> get props => [english];
}
