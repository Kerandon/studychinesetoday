import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/flip_animation.dart';
import 'package:studychinesetoday/components/app/display_image.dart';
import 'package:studychinesetoday/utils/enums/card_stages.dart';
import 'package:studychinesetoday/utils/enums/slide_direction.dart';
import 'package:studychinesetoday/utils/methods.dart';
import '../../../animations/slide_animation.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/constants.dart';
import '../../../models/word_data.dart';
import 'flashcard_provider.dart';

class Flashcard extends ConsumerStatefulWidget {
  const Flashcard({
    super.key,
    required this.index,
    required this.word,
    this.slideDirection = SlideDirection.none,
    required this.noFlipUI,
  });

  final int index;
  final WordData word;
  final SlideDirection slideDirection;
  final bool noFlipUI;

  @override
  ConsumerState<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends ConsumerState<Flashcard> {
  late final Future<String> _futureImage;

  @override
  void initState() {
    _futureImage = getWordURL(topic: widget.word.topicData!, word: widget.word);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double flipCardRadians = 0;

    final size = MediaQuery.of(context).size;

    double indexMultiplier = 300;

    double xAlignment = widget.index / indexMultiplier * -1;
    double yAlignment = widget.index / indexMultiplier * 1;

    final FlashcardManager flashcardManager = ref.watch(flashcardProvider);
    final FlashcardNotifier flashcardNotifier =
        ref.read(flashcardProvider.notifier);

    bool flipCard = false;

    flashcardManager.flipCard.entries.firstWhere((element) {
      if (element.key == widget.index) {
        if (element.value == true) {
          flipCard = true;
        }
      }
      return false;
    }, orElse: () => const MapEntry(0, false));

    bool hasFlipped = false;
    for (var f in flashcardManager.hasHalfFlipped) {
      if (f.entries.first.key == widget.index) {
        hasFlipped = f.entries.first.value;
        if (hasFlipped) {
          if (!widget.noFlipUI) {
            flipCardRadians = pi;
          }
        }
      }
    }

    Color borderColor = Colors.black12;
    if (widget.slideDirection == SlideDirection.right) {
      borderColor = Colors.green;
    }
    if (widget.slideDirection == SlideDirection.left) {
      borderColor = Colors.red;
    }

    return FlipAnimation(
      animate: flipCard,
      index: widget.index,
      halfFlipCompleted: () {
        flashcardNotifier.setCardState(stage: CardStage.swipe);
      },
      child: SlideAnimation(
        animate: widget.slideDirection != SlideDirection.none,
        slideDirection: widget.slideDirection,
        slideCompleted: () {
          flashcardNotifier.setFlip(flip: {widget.index: false});
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
                      Expanded(
                        child: DisplayImage(
                          imageFuture: _futureImage,
                          returnedURL: (data) {},
                        ),
                      ),
                      Expanded(
                        child: Center(
                            child: Text(
                                '${widget.index} ${widget.word.english}',
                                style:
                                    Theme.of(context).textTheme.displayMedium)),
                      ),
                    ] else ...[
                      Expanded(
                        child: Center(
                          child: Text(widget.word.character,
                              style: Theme.of(context).textTheme.displayMedium),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(widget.word.pinyin,
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
