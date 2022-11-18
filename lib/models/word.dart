import 'package:equatable/equatable.dart';
import 'package:studychinesetoday/models/topic.dart';

class Word extends Equatable {
  final Topic topic;
  final String english;
  final String character;
  final String pinyin;
  final String? url;

  const Word(
      {required this.topic,
      required this.english,
      required this.character,
      required this.pinyin,
      this.url});

  static Word fromMap(
      {required Topic topic, required MapEntry<String, dynamic> mapEntry, String? url}) {
    String english = mapEntry.key;
    Map<String, dynamic> topicData = mapEntry.value;
    String character = topicData.entries
        .firstWhere((element) => element.key == 'character')
        .value;
    String pinyin = topicData.entries
        .firstWhere((element) => element.key == 'pinyin')
        .value;
    return Word(
      topic: topic,
        english: english, character: character, pinyin: pinyin, url: url);
  }

  @override
  List<Object> get props => [english];
}
