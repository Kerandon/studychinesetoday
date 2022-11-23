import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/utils/enums/session_type.dart';
import '../../configs/app_colors.dart';
import '../../configs/constants.dart';
import '../../models/topic_data.dart';
import '../../models/word_data.dart';
import '../../sections/games/flashcards/flash_cards_page.dart';
import '../../sections/games/flashcards/flashcard_provider.dart';
import '../app/loading_helper.dart';

class ActivityThumbnail extends ConsumerWidget {
  const ActivityThumbnail({
    super.key,
    required this.topic,
  });

  final TopicData topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.20,
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
                      futures: [

                        FirebaseFirestore.instance
                            .collection(kTopics)
                            .doc(topic.english)
                            .get(),

                      ],
                      onFutureComplete: (data) {


                        Set<WordData> cards = {};
                        final document =
                            data[0] as DocumentSnapshot<Map<String, dynamic>>;
                        for (var d in document.data()!.entries) {
                          if (d.key != 'topicdata') {
                           // cards.add(Word.fromMap(topic: topic, mapEntry: d));
                          }
                        }

                        final provider = ref.read(flashcardProvider.notifier);
                        provider.setWords(
                            sessionType: SessionType.newSession, cards: cards);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FlashcardsPage(
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
