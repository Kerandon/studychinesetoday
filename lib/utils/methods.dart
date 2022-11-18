import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:studychinesetoday/configs/constants.dart';

import '../models/topic.dart';
import '../models/word.dart';

Future<Set<Topic>> getAllTopics() async {
  Set<Topic> topics = {};
  final snapshot = await FirebaseFirestore.instance.collection(kTopics).get();
  for (var d in snapshot.docs) {
    Map<String, dynamic> topicData = d.get('topicdata');
    String character = topicData.entries
        .firstWhere((element) => element.key == 'character')
        .value;
    String pinyin = topicData.entries
        .firstWhere((element) => element.key == 'pinyin')
        .value;

    topics.add(Topic(english: d.id, character: character, pinyin: pinyin));
  }

  return topics;
}

Future<String> getThumbnailURL({required Topic topic}) async {
  final ref = FirebaseStorage.instance.ref('topics/${topic.english}');
  final all = await ref.listAll();
  final r = Random().nextInt(all.items.length);
  return await all.items[r].getDownloadURL();
}

Future<Map<String, String>> getAllTopicItemsUrls({required Topic topic}) async {
  Map<String, String> urls = {};
  final ref = FirebaseStorage.instance.ref('topics/${topic.english}');
  final all = await ref.listAll();
  for (var i in all.items) {
    urls.addAll({i.name.substring(0, i.name.indexOf('.')): await i.getDownloadURL()});
  }
  return urls;
}

Future<String> getTopicItemImage({required Word word}) async {
  return await FirebaseStorage.instance.ref('topics/${word.topic.english}/${word.english}.png').getDownloadURL();


}


Future<DocumentSnapshot<Map<String, dynamic>>> getAllTopicItems({required Topic topic}) async {
  return await FirebaseFirestore.instance.collection(kTopics).doc(topic.english).get();
}