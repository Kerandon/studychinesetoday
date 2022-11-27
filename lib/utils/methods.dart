import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:studychinesetoday/configs/constants.dart';
import '../models/topic_data.dart';
import '../models/word_data.dart';
import '../state_management/topics_data.dart';

Future<String> getRandomTopicURL({required TopicData topic}) async {
  final ref = FirebaseStorage.instance.ref('topics/${topic.english}');
  final all = await ref.listAll();
  final r = Random().nextInt(all.items.length);
  return await all.items[r].getDownloadURL();
}

Future<String> getWordURL(
    {required TopicData topic, required WordData word}) async {
  return await FirebaseStorage.instance
      .ref('topics/${topic.english}/${word.english}.png')
      .getDownloadURL();
}

Future<Set<WordData>> getWordsURLs({required Set<WordData> words}) async {
  final instance = FirebaseStorage.instance;

  Set<WordData> updatedWords = {};

  for (var w in words) {
    String? url;

    if (w.url == null || w.url == "") {
      try {
        url = await instance
            .ref('topics/${w.topicData!.english}/${w.english}.png')
            .getDownloadURL();
      } on FirebaseException catch (e) {
        throw Exception(e.message);
      }
      updatedWords.add(
        WordData(
            english: w.english,
            character: w.character,
            pinyin: w.pinyin,
            topicData: w.topicData,
            url: url),
      );
    }
  }

  return updatedWords;
}

Future<Set<TopicData>> getAllTopicsData() async {
  final snapshot =
      await FirebaseFirestore.instance.collectionGroup(kTopics).get();

  Set<TopicData> topicDataList = {};

  for (var d in snapshot.docs) {
    String topicEnglish = d.id;
    Map<String, dynamic> topicData = d.get(kTopicData);
    String topicCharacter = topicData.entries
        .firstWhere((element) => element.key == kCharacter)
        .value;
    String topicPinyin =
        topicData.entries.firstWhere((element) => element.key == kPinyin).value;
    Set<WordData> wordData = {};
    for (var w in d.data().entries) {
      final data = w.value as Map<String, dynamic>;
      final wordCharacter =
          data.entries.firstWhere((element) => element.key == kCharacter).value;
      final wordPinyin =
          data.entries.firstWhere((element) => element.key == kPinyin).value;
      if (w.key != kTopicData) {
        wordData.add(WordData(
            english: w.key, character: wordCharacter, pinyin: wordPinyin));
      }
    }

    topicDataList.add(TopicData(
        english: topicEnglish,
        character: topicCharacter,
        pinyin: topicPinyin,
        words: wordData));
  }

  return topicDataList;
}

Future<Set<WordData>> allWordsToList(
    {required TopicsDataState topicsDataState, bool getURLs = false}) async {
  final firebaseStorage = FirebaseStorage.instance;

  Set<WordData> allWords = {};
  for (var t in topicsDataState.allTopicsData) {
    for (var w in t.words!) {
      String? url;

      if (getURLs) {
        if (w.english != kTopicData) {
          if (w.url == null || w.url == "") {
            try {
              url = await firebaseStorage
                  .ref('topics/${t.english}/${w.english}.png')
                  .getDownloadURL();
            } on FirebaseException catch (e) {
              throw Exception(e.message);
            }
          }
        }
      }

      allWords.add(WordData(
          english: w.english,
          character: w.character,
          pinyin: w.pinyin,
          topicData: t,
          url: url));
    }
  }

  return allWords;
}

Set<WordData> shuffleAllWords(
    {required Set<WordData> allWordsSet, int? limit}) {
  List<WordData> allWordsList = allWordsSet.toList();
  allWordsList = allWordsList
    ..shuffle()
    ..toSet();
  allWordsSet = allWordsList.toSet();
  if (limit != null) {
    allWordsSet = allWordsSet.take(limit).toSet();
  }
  return allWordsSet;
}
