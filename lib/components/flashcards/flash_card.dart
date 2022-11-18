import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/flip_animation.dart';
import 'package:studychinesetoday/components/home/topic_thumbail.dart';
import 'package:studychinesetoday/utils/enums/card_stages.dart';

import 'package:studychinesetoday/utils/enums/slide_direction.dart';
import 'package:studychinesetoday/utils/methods.dart';

import '../../animations/slide_animation.dart';
import '../../configs/app_colors.dart';

import '../../configs/constants.dart';
import '../../models/word.dart';
import '../../state_management/flashcard_provider.dart';

class Flashcard extends ConsumerWidget {
  const Flashcard({
    super.key,
    required this.index,
    required this.word,
    this.slideDirection = SlideDirection.none,
    required this.noFlipUI,
  });

  final int index;
  final Word word;
  final SlideDirection slideDirection;
  final bool noFlipUI;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double flipCardRadians = 0;

    final size = MediaQuery.of(context).size;

    double xAlignment = index / 120 * -1;
    double yAlignment = index / 80 * 1;

    final FlashcardManager flashcardManager = ref.watch(flashcardProvider);
    final FlashcardNotifier flashcardNotifier =
        ref.read(flashcardProvider.notifier);

    bool flipCard = false;
    //
    flashcardManager.flipCard.entries.firstWhere((element) {
      if (element.key == index) {
        if (element.value == true) {
          flipCard = true;
        }
      }
      return false;
    }, orElse: () => const MapEntry(0, false));
    //
    bool hasFlipped = false;
    for (var f in flashcardManager.hasHalfFlipped) {
      if (f.entries.first.key == index) {
        hasFlipped = f.entries.first.value;
        if (hasFlipped) {
          if (!noFlipUI) {
            flipCardRadians = pi;
          }
        }
      }
    }
    // String url = flashcardManager.urls.entries
    //     .firstWhere((element) => element.key == topic.english)
    //     .value;

    Color borderColor = Colors.black12;
    if(slideDirection == SlideDirection.right){
      borderColor = Colors.green;
    }
    if(slideDirection == SlideDirection.left){
      borderColor = Colors.red;
    }


    return
      //Container(color: Colors.amber, height: 50, width: 50,);

      FlipAnimation(
      animate: flipCard,
      index: index,
      flipCompleted: () {
        flashcardNotifier.setCardState(stage: CardStage.swipe);
      },
      child: SlideAnimation(
        animate: slideDirection != SlideDirection.none,
        slideDirection: slideDirection,
        slideCompleted: () {
          flashcardNotifier.setFlip(flip: {index: false});
          flashcardNotifier.setCardState(stage: CardStage.flip);
        },
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(flipCardRadians),
          child: Align(
            alignment: Alignment(xAlignment, yAlignment),
            child: Container(
              width: size.width * 0.20,
              height: size.height * 0.50,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 8),
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(kRadius),
                boxShadow: const [kShadow],
              ),
              child: Center(
                child: Column(
                  children: [
                    if (!hasFlipped) ...[

                      DisplayImage(

                        imageFuture: getTopicItemImage(word: word),
                        returnedURL: (url) {  },

                      ),

                      // Expanded(
                      //   flex: 3,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(28.0),
                      //     child: Image.network(url),
                      //   ),
                      // ),
                      Expanded(
                        child: Center(
                            child: Text(word.english,
                                style:
                                    Theme.of(context).textTheme.displayMedium)),
                      ),
                    ] else ...[
                      // Expanded(
                      //   flex: 3,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(28.0),
                      //     child: Image.network(url),
                      //   ),
                      // ),
                      Expanded(
                        child: Center(
                          child: Text(
                            word.character,
                            style: Theme.of(context).textTheme.displayMedium ),
                        ),
                        ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(word.pinyin,
                              style: Theme.of(context).textTheme.displaySmall),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
