import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/pages/topic_page.dart';
import 'package:studychinesetoday/utils/enums/card_stages.dart';
import 'package:studychinesetoday/utils/enums/session_type.dart';
import 'package:studychinesetoday/utils/enums/slide_direction.dart';
import '../components/flashcards/flash_card.dart';
import '../components/flashcards/side_bar_flashcards.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../state_management/flashcard_provider.dart';

class FlashcardsPage extends ConsumerStatefulWidget {
  const FlashcardsPage({required this.topic, Key? key})
      : super(key: key);

  final Topic topic;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends ConsumerState<FlashcardsPage> {
  List<Word> words = [];
  List<Flashcard> flashcardsUnanswered = [],
      flashcardsCorrect = [],
      flashcardsIncorrect = [];

  late int currentIndex;
  CardStage cardStage = CardStage.flip;
  bool haveSetUp = false;

  @override
  Widget build(BuildContext context) {



    final size = MediaQuery.of(context).size;

    final FlashcardManager flashcardManager = ref.watch(flashcardProvider);
    final FlashcardNotifier flashcardNotifier = ref.read(flashcardProvider.notifier);

    if (!haveSetUp) {

      print('topic passed in ${widget.topic.english}');

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        words.clear();

        //flashcardNotifier.setUnansweredWords(words: words);

        print(flashcardManager.unansweredWords.length);

        words = flashcardManager.unansweredWords.toList();

        print('number of words to use ${words.length}');

        for(int i = 0; i < words.length; i++){
          flashcardsUnanswered.add(Flashcard(index: i, word: words[i], noFlipUI: false));
        }

        currentIndex = words.length - 1;


        // currentIndex = (words.length - 1);
        //
        // for (int i = 0; i < currentIndex + 1; i++) {
        //   print(i);
        //
        //   // flashcardsUnanswered.add(
        //   //   Flashcard(
        //   //     index: i,
        //   //     topic: words[i],
        //   //     noFlipUI: false,
        //   //   ),
        //   // );
        // }

        flashcardNotifier.setTotalCards(total: currentIndex);
        haveSetUp = true;
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
              MaterialPageRoute(
                builder: (context) => TopicPage(
                  topic: widget.topic,
                ),
              ),
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
                                            word: words[currentIndex],
                                            noFlipUI: true,
                                          ),
                                        );
                                        flashcardNotifier.addToCorrectCards(
                                            card: words[currentIndex]);
                                        flashcardsUnanswered
                                            .removeAt(currentIndex);
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
                                            word: words[currentIndex],
                                            noFlipUI: true));
                                        flashcardNotifier.addToIncorrectCards(
                                            card: words[currentIndex]);
                                        flashcardsUnanswered
                                            .removeAt(currentIndex);
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
                                builder: (context) => FlashcardsPage(
                                  topic: widget.topic,
                                ),
                              ),
                            );
                          },
                          child: Text('Replay incorrect cards', style: Theme.of(context).textTheme.bodyMedium,),
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
                                  builder: (context) => FlashcardsPage(
                                    topic: widget.topic,
                                  ),
                                ),
                              );
                            },
                            child: Text('Replay all cards',  style: Theme.of(context).textTheme.bodyMedium))
                      ],
              ));
    });
  }
}
