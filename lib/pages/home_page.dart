import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/components/app/loading_helper.dart';
import 'package:studychinesetoday/components/home/topics_carousel.dart';
import 'package:studychinesetoday/configs/app_colors.dart';
import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/pages/flash_cards_page.dart';
import 'package:studychinesetoday/state_management/flashcard_provider.dart';
import 'package:studychinesetoday/state_management/topic_providers.dart';
import 'package:studychinesetoday/utils/methods.dart';

import '../models/topic.dart';
import '../models/word.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final topicNotifier = ref.read(topicProvider.notifier);
    final flashcardNotifier = ref.read(flashcardProvider.notifier);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Chinese Today'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: size.height * 0.50,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: const Alignment(0.4, 0),
                            child: SizedBox(
                              width: size.width * 0.30,
                              child: AutoSizeText(
                                'Studying Chinese today couldn\'t be easier!',
                                style: Theme.of(context).textTheme.displayLarge,
                                minFontSize: 20,
                                maxFontSize: 40,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: const Alignment(-0.4, 0),
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.02),
                              child: Image.asset(
                                  'assets/images/app/background_main.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(26.0),
                child: Container(
                  width: size.width * 0.80,
                  height: size.height * 0.30,
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(kRadius),
                  ),
                  child: ElevatedButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => LoadingHelper(
                              futures: [
                                getAllTopics(),
                              ],
                              onFutureComplete: (data) {
                                Set<Topic> topics = <Topic>{};
                                for (var d in data[0] as Set<Topic>) {
                                  topics.add(d);
                                }

                                WidgetsBinding.instance.addPostFrameCallback(
                                  (timeStamp) {
                                    topicNotifier.addTopics(topics: topics);
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                      (timeStamp) {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                LoadingHelper(
                                                    futures: [
                                                  getAllTopicItems(
                                                      topic: topics.last)
                                                ],
                                                    onFutureComplete: (data) {
                                                      final docs = data[0]
                                                          as List<
                                                              MapEntry<String,
                                                                  dynamic>>;

                                                      List<Word> words = [];

                                                      for (var d in docs) {
                                                        words.add(Word.fromMap(
                                                            topic: topics.last,
                                                            mapEntry: d));
                                                      }

                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (timeStamp) {
                                                        flashcardNotifier
                                                            .setUnansweredWords(
                                                                words: words);



                                                          Navigator.of(context).push(
                                                              PageRouteBuilder(
                                                                  pageBuilder: (_,
                                                                          __,
                                                                          ___) =>
                                                                      FlashcardsPage(
                                                                          topic:
                                                                              topics.last)));
                                                        });
                                                    }),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Flashcards',
                        style: Theme.of(context).textTheme.displayMedium,
                      )),
                ),
              ),
              const TopicsCarousel()
            ],
          ),
        ),
      ),
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
    );
  }
}
