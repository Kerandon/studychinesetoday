import '../../../../models/word_data.dart';

class Sentence {
  final List<WordData> wordDataList;
  final String english;
  final List<String> grammarStructure;

  Sentence(
      {required this.wordDataList,
        required this.english,
        required this.grammarStructure});
}