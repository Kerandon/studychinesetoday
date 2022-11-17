import 'package:equatable/equatable.dart';

class Topic extends Equatable {
  final String english;
  final String character;
  final String pinyin;
  final String? url;

  const Topic({required this.english, required this.character, required this.pinyin, this.url});

  static Topic fromMap({required MapEntry<String, dynamic> mapEntry, String? url}){
    String english = mapEntry.key;
    Map<String, dynamic> topicData = mapEntry.value;
    String character = topicData.entries.firstWhere((element) => element.key == 'character').value;
    String pinyin = topicData.entries.firstWhere((element) => element.key == 'pinyin').value;
    return Topic(english: english, character: character, pinyin: pinyin, url: url);
  }

  @override
  List<Object> get props => [english];

}
