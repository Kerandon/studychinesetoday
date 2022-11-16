import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/pages/flash_cards_page.dart';
import 'package:studychinesetoday/state_management/flashcard_provider.dart';
import 'package:studychinesetoday/utils/enums/session_type.dart';
import 'package:studychinesetoday/utils/methods.dart';

import '../../configs/app_colors.dart';
import '../../configs/constants.dart';
import '../../models/topic.dart';
import '../app/loading_helper.dart';

class ActivityThumbnail extends ConsumerWidget {
  const ActivityThumbnail({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.20,
      height: size.height * 0.30,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: const [kShadow],
      ),
      child: Column(
        children: [
          Expanded(
            child: Text(
              'Flashcards!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                final flashcardNotifier = ref.watch(flashcardProvider.notifier);
                flashcardNotifier.reset(newSession: true);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, __, ___) => LoadingHelper(
                      future: [
                        FirebaseFirestore.instance
                            .collection(kTopics)
                            .doc(topic.english)
                            .get(),
                        getAllTopicItemsUrls(topic: topic)
                      ],
                      onFutureComplete: (data) {
                        List<Topic> cards = [];
                        final document =
                            data[0] as DocumentSnapshot<Map<String, dynamic>>;
                        for (var d in document.data()!.entries) {
                          if (d.key != 'topicdata') {
                            cards.add(Topic.fromMap(mapEntry: d));
                          }
                        }

                        final provider = ref.read(flashcardProvider.notifier);
                        provider.setURLs(urls: data[1]);
                        provider.setWords(
                            sessionType: SessionType.newSession, cards: cards);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FlashcardsPage(
                              topic: topic,
                              words: const [],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: const Text('Start!'),
            ),
          ),
        ],
      ),
    );
  }
}
