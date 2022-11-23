import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AllTopics extends ConsumerWidget {
  const AllTopics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
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
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.10, size.height * 0.05, size.width * 0.10, 0),
              child: const Center(
                // child: Wrap(
                //   children: topics
                //       .map((e) => TopicThumbnail(
                //           topic: topics.firstWhere((element) =>
                //               element.english == topics.first.english)
                //
                //   ),
                //   )
                //       .toList(),
                // ),
              ),
            ),
          )),
    );
  }
}
