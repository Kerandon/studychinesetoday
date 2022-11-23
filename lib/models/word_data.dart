import 'package:equatable/equatable.dart';
import 'package:studychinesetoday/models/topic_data.dart';

class WordData extends Equatable {
  final String english;
  final String character;
  final String pinyin;
  final String? url;
  final TopicData? topicData;

  const WordData({
    required this.english,
    required this.character,
    required this.pinyin,
    this.topicData,
    this.url,
  });

  @override
  List<Object> get props => [english];

  static WordData copyWith(
      {required WordData wordData, String? url}) {
    return WordData(
        english: wordData.english,
        character: wordData.character,
        pinyin: wordData.pinyin,
        topicData: wordData.topicData,
        url: url);
  }
}
