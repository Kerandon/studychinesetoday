import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/components/home/topic_thumbail.dart';
import 'package:studychinesetoday/state_management/simple_providers.dart';

class AllTopics extends ConsumerWidget {
  const AllTopics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final topics = ref.read(allTopics).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Chinese Today!'),
      ),
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Choose a topic and start learning!'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: GridView.builder(
          padding: EdgeInsets.only(
              left: size.width * 0.05,
              top: size.height * 0.02,
              right: size.width * 0.05),
          itemCount: topics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemBuilder: (context, index) => TopicThumbnail(topic: topics[index]),
        ),
      ),
    );
  }
}
