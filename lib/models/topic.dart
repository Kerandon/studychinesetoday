class Topic {
  final String english;
  final String character;
  final String pinyin;

  Topic({required this.english, required this.character, required this.pinyin});

  static Topic fromMap({required MapEntry<String, dynamic> mapEntry}){
    String english = mapEntry.key;
    Map<String, dynamic> topicData = mapEntry.value;
    String character = topicData.entries.firstWhere((element) => element.key == 'character').value;
    String pinyin = topicData.entries.firstWhere((element) => element.key == 'pinyin').value;
    return Topic(english: english, character: character, pinyin: pinyin);

  }
}
