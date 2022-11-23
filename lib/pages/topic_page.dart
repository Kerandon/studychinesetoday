import 'package:flutter/material.dart';
import 'package:studychinesetoday/components/topic/activity_thumbnail.dart';
import '../models/topic_data.dart';

class TopicPage extends StatelessWidget {
  const TopicPage({Key? key, required this.topic}) : super(key: key);

  final TopicData topic;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Chinese Today'),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: Text('${topic.english} ${topic.character}  ${topic.pinyin}'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: GridView(
          padding: EdgeInsets.only(
              left: size.width * 0.10,
              top: size.height * 0.02,
              right: size.width * 0.10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, mainAxisSpacing: 24, crossAxisSpacing: 24),
          children: [
            ActivityThumbnail(topic: topic),
          ],
        ),
      ),
    );
  }
}
