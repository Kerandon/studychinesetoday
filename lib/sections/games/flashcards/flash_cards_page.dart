import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/sections/games/flashcards/side_bar_flashcards.dart';
import 'package:studychinesetoday/state_management/topics_data.dart';
import 'package:studychinesetoday/utils/enums/card_stages.dart';
import 'package:studychinesetoday/utils/enums/session_type.dart';
import 'package:studychinesetoday/utils/enums/slide_direction.dart';
import '../../../../models/topic_data.dart';
import '../../../../models/word_data.dart';
import '../../home_page/home_page.dart';
import '../../home_page/home_page_2.dart';
import 'flash_card.dart';
import 'flashcard_provider.dart';


class FlashcardsPage extends ConsumerStatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends ConsumerState<FlashcardsPage> {
  Set<WordData> words = {};
  Set<Flashcard> flashcardsUnanswered = {},
      flashcardsCorrect = {},
      flashcardsIncorrect = {};

  late int currentIndex;
  CardStage cardStage = CardStage.flip;
  bool _haveSetUp = false;
  int preferredNumberCards = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FlashcardManager flashcardManager = ref.watch(flashcardProvider);
    final FlashcardNotifier flashcardNotifier =
        ref.read(flashcardProvider.notifier);
    final TopicsDataState topicsDataState = ref.read(topicsDataProvider);

    if (!_haveSetUp) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (flashcardManager.roundIndex == 0) {
          Set<TopicData> topicData = topicsDataState.allTopicsData;

          for (var t in topicData) {
            for (var w in t.words!) {
              if (w.english != kTopicData) {
                words.add(WordData(
                    english: w.english,
                    character: w.character,
                    pinyin: w.pinyin,
                    topicData: TopicData(english: t.english, character: t.character, pinyin: t.pinyin)
                ),
                );
              }
            }
          }

          flashcardNotifier.setUnansweredWords(words: words);
        } else {
          words = flashcardManager.unansweredWords.toSet();
        }

        words = words.take(100).toSet();
        words = words..toList().shuffle();

        for (int i = 0; i < words.length; i++) {
          flashcardsUnanswered.add(
              Flashcard(index: i, word: words.elementAt(i), noFlipUI: false));
        }

        currentIndex = words.length - 1;

        flashcardNotifier.setTotalCards(total: currentIndex);

        _haveSetUp = true;
      });
    }

    if (flashcardManager.roundCompleted) {
      _onRoundCompleted(context, flashcardManager, flashcardNotifier);
    }

    cardStage = flashcardManager.cardStage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Chinese Today'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage2()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Flashcards'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height * 1.5,
            child: Row(
              children: [
                const SideBarFlashcards(),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: size.width * 0.30,
                          height: size.height * 0.60,
                          child: Stack(
                            children: [
                              Stack(children: flashcardsUnanswered.toList()),
                              Stack(children: flashcardsIncorrect.toList()),
                              Stack(children: flashcardsCorrect.toList()),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width * 0.30,
                          height: size.height * 0.20,
                          color: Colors.grey,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: cardStage == CardStage.flip &&
                                        !flashcardManager.roundCompleted
                                    ? () {
                                        flashcardNotifier.setFlip(
                                            flip: {currentIndex: true});
                                        flashcardNotifier.setCardState(
                                            stage: CardStage.none);
                                      }
                                    : null,
                                icon: const Icon(Icons.turn_left),
                              ),
                              IconButton(
                                onPressed: cardStage == CardStage.swipe
                                    ? () {
                                        flashcardsCorrect.add(
                                          Flashcard(
                                            index: currentIndex,
                                            slideDirection:
                                                SlideDirection.right,
                                            word: words.elementAt(currentIndex),
                                            noFlipUI: true,
                                          ),
                                        );
                                        flashcardNotifier.addToCorrectCards(
                                          card: words.elementAt(currentIndex),
                                        );
                                        flashcardsUnanswered.removeWhere(
                                            (element) =>
                                                element.index == currentIndex);
                                        currentIndex--;
                                        flashcardNotifier.setCurrentIndex(
                                            total: currentIndex);
                                        flashcardNotifier.setCardState(
                                            stage: CardStage.none);
                                        setState(() {});
                                      }
                                    : null,
                                icon: const Icon(Icons.check),
                              ),
                              IconButton(
                                onPressed: cardStage == CardStage.swipe
                                    ? () {
                                        flashcardsIncorrect.add(Flashcard(
                                            index: currentIndex,
                                            slideDirection: SlideDirection.left,
                                            word: words.elementAt(currentIndex),
                                            noFlipUI: true));

                                        flashcardNotifier.addToIncorrectCards(
                                          card: words.elementAt(0),
                                        );
                                        flashcardsUnanswered.removeWhere(
                                            (element) =>
                                                element.index == currentIndex);
                                        currentIndex--;

                                        flashcardNotifier.setCurrentIndex(
                                            total: currentIndex);
                                        setState(() {});
                                      }
                                    : null,
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRoundCompleted(BuildContext context,
      FlashcardManager flashcardsManager, FlashcardNotifier flashcardNotifier) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Round completed!'),
                actions: flashcardsManager.sessionCompleted
                    ? null
                    : [
                        ElevatedButton(
                          onPressed: () {
                            flashcardNotifier
                              ..setRoundCompleted(completed: false)
                              ..setWords(
                                  sessionType: SessionType.repeatIncorrect)
                              ..reset(newSession: false);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FlashcardsPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Replay incorrect cards',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              flashcardNotifier
                                ..setRoundCompleted(completed: false)
                                ..setWords(
                                    sessionType: SessionType.repeatAllWords)
                                ..reset(newSession: false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FlashcardsPage(),
                                ),
                              );
                            },
                            child: Text('Replay all cards',
                                style: Theme.of(context).textTheme.bodyMedium))
                      ],
              ),);
    },);
  }
}
